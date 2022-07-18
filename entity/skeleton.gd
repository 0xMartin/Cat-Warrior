extends KinematicBody2D


export var gravity = 1000
export var lives = 45
export var damage = 10
export var speed = 80


var move = Vector2()
var run = false
var rng = RandomNumberGenerator.new()
var explosion = preload("res://entity/fx/explosion.tscn").instance()


func _ready():
	$health_bar.init(lives)


func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return
		
	# gravitace
	move.y += min(gravity * delta, 1600);
	
	if lives > 0 and position.y < 1000:
		# akce
		actions(delta)
	else:
		# smrt
		move.x = 0
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
				$AnimatedSprite.play("walk")
				$AnimatedSprite.flip_h = false
				move.x = -speed
				if dist < 300:
					state = 3
		2:
			# doprava
			if $RayCastRight2.is_colliding() or not $RayCastRight.is_colliding() or wait <= 0:
				state = 0
				wait = rng.randi_range(60, 300)
			else:
				$AnimatedSprite.play("walk")
				$AnimatedSprite.flip_h = true
				move.x = speed
				if dist < 300:
					state = 3
		3:
			# dojit k hraci
			if x_dir > 0:
				if not $RayCastRight2.is_colliding() and $RayCastRight.is_colliding():
					move.x = speed
					$AnimatedSprite.play("walk")
					$AnimatedSprite.flip_h = false
				else:
					$AnimatedSprite.play("idle")	
			else:
				if not $RayCastLeft2.is_colliding() and $RayCastLeft.is_colliding():
					move.x = -speed	
					$AnimatedSprite.play("walk")
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.play("idle")	
			if dist < 100:
				state = 4
			elif dist > 300:
				state = 0
				wait = rng.randi_range(60, 300)
		4:
			# utocit
			if $AnimatedSprite.animation != "attack":
				$AnimatedSprite.play("attack")
			if dist > 100:
				state = 3
	wait -= 1

		
# zasah
func hit(damage):
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)


# zabije po prehrani animace
func _on_AnimatedSprite_animation_finished():
	if lives <= 0:
		if $AnimatedSprite.animation == "death":
			# exploze
			get_parent().add_child(explosion)
			var p = position
			p.y += 20
			explosion.init(p, Color.darkgray, 150, 300, 6, 0.25, 0.1)
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
