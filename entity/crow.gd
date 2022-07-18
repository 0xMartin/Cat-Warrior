extends KinematicBody2D


export var speed = 100
export var lives = 20
export var damage = 8
export var gravity = 600


var move = Vector2()
var rng = RandomNumberGenerator.new()
var death = preload("res://entity/fx/death_body_parts.tscn")


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


var waiting = 0
var state = 3

func actions(delta):
	if $Down.is_colliding() or position.y < 100:
		var g = move.y
		move.y = -120 - g / 2
		
	waiting -= 1
	match state:
		0:
			if waiting <= 0:
				waiting = rng.randf_range(100, 300)
				if $Left.is_colliding():
					state = 2
				elif $Right.is_colliding():
					state = 1
				else:
					if rng.randi() % 2 == 0:
						state = 1
					else:
						state = 2
		1:
			if waiting <= 0 or $Left.is_colliding():
				state = 3
			$AnimatedSprite.flip_h = true
			move.x = -speed
		2:
			if waiting <= 0 or $Right.is_colliding():
				state = 3
			$AnimatedSprite.flip_h = false
			move.x = speed
		3:
			move.x = 0
			waiting = rng.randf_range(50, 300)
			state = 0


func hit(damage):
	lives = max(0, lives - damage)
	waiting = 0
	$health_bar.setLive(lives)


func _on_AttackTimer_timeout():
	if GameConfig.current_player != null and GameConfig.physics_enabled:
		Sound.hit2()
		GameConfig.current_player.hit(damage)	
