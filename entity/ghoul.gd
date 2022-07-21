extends KinematicBody2D


export var gravity = 1000
export var lives = 20
export var damage = 70
export var speed = 140
const detect_range = 400


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
		kill()

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
			# doleva
			if $RayCastLeft2.is_colliding() or not $RayCastLeft.is_colliding():
				state = 1
			else:
				$AnimatedSprite.play("walk")
				$AnimatedSprite.flip_h = false
				move.x = -speed
			if dist < detect_range and wait <= 0:
				state = 2
		1:
			# doprava
			if $RayCastRight2.is_colliding() or not $RayCastRight.is_colliding():
				state = 0
			else:
				$AnimatedSprite.play("walk")
				$AnimatedSprite.flip_h = true
				move.x = speed
			if dist < detect_range and wait <= 0:
				state = 2
		2:
			if x_dir > 0:
				if not $RayCastRight.is_colliding():
					state = 0
					wait = 50
				else:
					$AnimatedSprite.flip_h = true
					move.x = speed
			else:
				if not $RayCastLeft.is_colliding():
					state = 1
					wait = 50
				else:
					$AnimatedSprite.flip_h = false
					move.x = -speed
					
			if dist < 100:
				targetHit()
				
			if dist > detect_range:
				wait = 50
				if rng.randi() % 2 == 0:
					state = 0
				else:
					state = 1
	wait = max(0, wait - 1)

		
# zasah
func hit(damage):
	# hp tag
	if lives > 0:
		var parent = get_parent()
		var hp_tag = hp_tag_scene.instance()
		hp_tag.init(position, damage)
		parent.add_child(hp_tag)
		
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)
	

func targetHit():
	if GameConfig.current_player != null:
		if GameConfig.current_player.lives > 0:
			GameConfig.current_player.hit(damage)	
			kill()
		

func kill():
	# zvuk
	Sound.explosion()
	# exploze
	get_parent().add_child(explosion)
	explosion.init(position, Color.orange, 300, 400, 8, 0.4, 0.2)
	# zabiti
	queue_free()
