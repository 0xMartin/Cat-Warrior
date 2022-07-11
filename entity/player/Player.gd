extends KinematicBody2D

# pocet zivotu
export var lives = 100

# poskozeni na vystrel
export var damage_shot = 5

# poskozeni na zasah z blizka
export var damage_hit = 10

# sila gravitace
export var gravity = 1000

# rychlost pohybu
export var speed = 200

# intenzita skoku
export var jump = 600


var no_action = false
var move = Vector2()

var bullet_scene = preload("res://entity/bullet/bullet_player.tscn")


func _physics_process(delta):
	# gravitace
	move.y += gravity * delta;
	
	# ovladani postavi (jen pokud stoji na zemi)
	if is_on_floor():
		var key_down = false
		if not no_action:
			# pohyb
			if Input.is_action_pressed("player_left") and position.x > 0:
				move.x = -speed	
				key_down = true
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("walk")
			if Input.is_action_pressed("player_right"):
				move.x = speed	
				key_down = true
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("walk")
			if Input.is_action_pressed("player_jump"):
				move.y = -jump
				key_down = true
				$AnimatedSprite.play("jump")
				
			# utok
			if Input.is_action_pressed("player_hit"):
				$AnimatedSprite.play("hit")
				$AnimatedSprite.offset.y = 2
				noActionMode()
				key_down = true
				
			# strelba
			if Input.is_action_pressed("player_shot"):
				$AnimatedSprite.play("shot")
				$AnimatedSprite.offset.y -= 4
				var bullet = bullet_scene.instance()
				bullet.init(not $AnimatedSprite.flip_h)
				if $AnimatedSprite.flip_h:
					bullet.position = $shot_left.global_position
					$AnimatedSprite.offset.x -= 10
				else:
					bullet.position = $shot_right.global_position
					$AnimatedSprite.offset.x += 10
				$"../".add_child(bullet)
				noActionMode()
				key_down = true
			
			# nedela nic
			if not key_down:
				move.x = 0	
				$AnimatedSprite.play("idle")
		else:
			# zastavi pohyb pokud napr. utoci
			move.x = 0
	else:	
		# animice pro pad
		if move.y > 0:
			$AnimatedSprite.play("fall")
		
	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))
	
	# smrt, pad dolu
	if position.y > 2000:
		queue_free()

func noActionMode():
	no_action = true

# po dokonceni animace navrat zpet do pohyboveho modu
func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.offset.x = 0
	$AnimatedSprite.offset.y = 0
	no_action = false
	
# nastavi kameru aktivni pro tuto entitu
func enableCamera():
	$Camera2D.current = true
	
# nastavi kameru neaktivni pro tuto entitu
func disableCamera():
	$Camera2D.current = false
