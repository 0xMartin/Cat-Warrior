extends KinematicBody2D


export var gravity = 1000
export var lives = 20
export var damage = 4
export var speed = 80


var move = Vector2()
var rng = RandomNumberGenerator.new()
var death = preload("res://entity/fx/death_body_parts.tscn")


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
	
	if lives > 0:
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
					$AnimatedSprite.play("walk")
					wait = rng.randi_range (60, 300)
				wait -= 1
			1:
				if not $RayCastLeft.is_colliding() or is_on_wall() or wait <= 0:
					state = 3	
				else:
					move.x = -speed
				wait -= 1
			2:
				if not $RayCastRight.is_colliding() or is_on_wall() or wait <= 0:
					state = 3
				else:
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
			if dist < 60:
				# jsou blizko sebe => zacne utocit na hrace
				$AnimatedSprite.play("attack")	
				wait = 20
				if $AttackTimer.time_left == 0:
					$AttackTimer.start()
			else:
				$AttackTimer.stop()
				# vyhledavani hrace
				if dist < 350:
					if GameConfig.current_player.position.x < position.x:
						state = 1
						$AnimatedSprite.flip_h = true
					else:
						state = 2
						$AnimatedSprite.flip_h = false
					$AnimatedSprite.play("walk")

# utok na hrace
func _on_AttackTimer_timeout():
	if GameConfig.current_player != null:
		GameConfig.current_player.hit(damage)	
		
		
# zasah
func hit(damage):
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)
