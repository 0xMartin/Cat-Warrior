extends KinematicBody2D



export var gravity = 1000
export var lives = 40
export var damage = 15
export var speed = 120
const detect_range = 450


var move = Vector2()
var run = false
var rng = RandomNumberGenerator.new()
var explosion = preload("res://entity/fx/explosion.tscn").instance()
var hp_tag_scene = preload("res://entity/hp_damage.tscn")


func _ready():
	$health_bar.init(lives)


func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return
	
	if lives > 0 and position.y < 1000:
		# gravitace
		move.y += min(gravity * delta, 1600);
		# akce
		actions(delta)
	else:
		# smrt
		move.x = 0
		move.y = 0
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play("death")

	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))


var state = 0
var wait = 0
func actions(delta):
	# vypocet vzdalenosti od hrace ...
	var dist = 9999
	var x_dir = 0
	if GameConfig.current_player != null:
		dist = GameConfig.current_player.position.distance_to(position)
		x_dir = GameConfig.current_player.position.x - position.x

	# stavy
	match state:
		0:
			# cekat
			move.x = 0
			$AnimatedSprite.play("idle")
			if wait <= 0:
				rng.randomize()
				wait = rng.randi_range(60, 300)
				if $RayCastLeft2.is_colliding() or not $RayCastLeft.is_colliding():
					state = 2
				elif $RayCastRight2.is_colliding() or not $RayCastRight.is_colliding():
					state = 1
				else:
					if rng.randi() % 2 == 0:
						state = 1
					else:
						state = 2
		1:
			# doleva
			if $RayCastLeft2.is_colliding() or not $RayCastLeft.is_colliding() or wait <= 0:
				state = 0
				wait = rng.randi_range(60, 300)
			else:
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("walk")
				move.x = -speed
				if dist < detect_range:
					state = 3
		2:
			# doprava
			if $RayCastRight2.is_colliding() or not $RayCastRight.is_colliding() or wait <= 0:
				state = 0
				wait = rng.randi_range(60, 300)
			else:
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("walk")
				move.x = speed
				if dist < detect_range:
					state = 3
		3:
			# dojit k hraci
			if x_dir > 0:
				$AnimatedSprite.flip_h = true
				if not $RayCastRight2.is_colliding() and $RayCastRight.is_colliding():
					move.x = speed
					$AnimatedSprite.play("walk")
				else:
					$AnimatedSprite.play("idle")
					move.x = 0
			else:
				$AnimatedSprite.flip_h = false
				if not $RayCastLeft2.is_colliding() and $RayCastLeft.is_colliding():
					move.x = -speed	
					$AnimatedSprite.play("walk")
				else:
					$AnimatedSprite.play("idle")	
					move.x = 0
			if dist < 110:
				state = 4
			elif dist > detect_range:
				state = 0
				wait = rng.randi_range(60, 300)
		4:
			# utocit
			if $AnimatedSprite.animation != "attack":
				$AnimatedSprite.play("attack")
			if dist > 110:
				state = 3
	wait -= 1

		
# zasah
func hit(damage):
	# hp tag
	if lives > 0:
		var parent = get_parent()
		var hp_tag = hp_tag_scene.instance()
		hp_tag.init(position, damage)
		parent.add_child(hp_tag)
		
	lives = max(0, lives - damage)
	
	if state != 4:
		state = 3
		
	$health_bar.setLive(lives)


# zabije po prehrani animace
func _on_AnimatedSprite_animation_finished():
	if lives <= 0:
		if $AnimatedSprite.animation == "death":
			# exploze
			get_parent().add_child(explosion)
			explosion.init($Position2D.global_position, Color.firebrick, 150, 300, 6, 0.25, 0.1)
			# zabiti
			queue_free()


# utok na hrace
func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation != "attack":
		return
	if $AnimatedSprite.frame != 4 and $AnimatedSprite.frame != 8:
		return
		
	if GameConfig.current_player != null and GameConfig.physics_enabled:
		Sound.hit2()
		GameConfig.current_player.hit(damage)	
