extends KinematicBody2D


export var gravity = 1000
export var lives = 35
export var damage = 5
export var speed = 80


var move = Vector2()
var run = false
var rng = RandomNumberGenerator.new()
var death = preload("res://entity/fx/death_body_parts.tscn")
var hp_tag_scene = preload("res://entity/hp_damage.tscn")


# 0 - idle
# 1 - walk left
# 2 - walk right
# 3 - waiting
var state = 0
var wait = 0


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
		$AttackTimer.stop()
		var d = death.instance()
		d.position = position
		get_parent().add_child(d)
		queue_free()

	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))


func actions(delta):
	if is_on_floor():
		# stavy
		match state:
			0:
				move.x = 0
				if wait <= 0:
					rng.randomize()
					if not $RayCastLeft.is_colliding():
						# pujde doprava
						state = 2
						$AnimatedSprite.flip_h = false
					elif not $RayCastRight.is_colliding():
						# pujde doleva
						state = 1
						$AnimatedSprite.flip_h = true
					else:
						# nahodny vyber smeru
						if rng.randi() % 2 == 1:
							state = 1
							$AnimatedSprite.flip_h = true
						else:
							state = 2
							$AnimatedSprite.flip_h = false
					wait = rng.randi_range (60, 300)
				wait -= 1
			1:
				if not $RayCastLeft.is_colliding() or wait <= 0 or $RayCastLeft2.is_colliding():
					state = 3	
				else:
					if run:
						$AnimatedSprite.play("run")
						move.x = -speed * 1.7
					else:
						$AnimatedSprite.play("walk")
						move.x = -speed
				wait -= 1
			2:
				if not $RayCastRight.is_colliding() or wait <= 0 or $RayCastRight2.is_colliding():
					state = 3
				else:
					if run:
						$AnimatedSprite.play("run")
						move.x = speed * 1.7
					else:
						$AnimatedSprite.play("walk")
						move.x = speed
				wait -= 1
			3:
				move.x = 0
				state = 0
				$AnimatedSprite.play("idle")
				rng.randomize()
				wait = rng.randi_range (60, 300)
				
		# vypocet vzadalenosti od hrace
		if state != 3:
			var dist = GameConfig.current_player.position.distance_to(position)
			if dist < 100:
				# jsou blizko sebe => zacne utocit na hrace
				$AnimatedSprite.play("attack")	
				wait = 20
				if $AttackTimer.time_left == 0:
					$AttackTimer.start()
			else:
				$AttackTimer.stop()
				# vyhledavani hrace
				if dist < 400:
					run = true
					if GameConfig.current_player.position.x < position.x:
						state = 1
						$AnimatedSprite.flip_h = true
					else:
						state = 2
						$AnimatedSprite.flip_h = false
				else:
					run = false

# utok na hrace
func _on_AttackTimer_timeout():
	if GameConfig.current_player != null and GameConfig.physics_enabled:
		Sound.hit2()
		GameConfig.current_player.hit(damage)	
		
		
# zasah
func hit(damage):
	# hp tag
	var parent = get_parent()
	if lives > 0:
		var hp_tag = hp_tag_scene.instance()
		hp_tag.init(position, damage)
		parent.add_child(hp_tag)
		
	wait = 1
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)
