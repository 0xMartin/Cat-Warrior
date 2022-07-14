extends KinematicBody2D

# pocet zivotu
export var lives = 100

# sila gravitace
export var gravity = 1000

# rychlost pohybu
export var speed = 200

# intenzita skoku
export var jump = 600

# true -> je mozne ovladat postavu
export var enabled = true


var no_action = false
var move = Vector2()

var bullet_scene = preload("res://entity/bullet/bullet_player.tscn")


func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return

	moveProcess(delta)
	particleProcess(delta)
	
	# smrt: pad dolu nebo ztrata vsech hp
	if position.y > 1000 or lives < 0:
		lives = max(lives, 0)
		GameConfig.current_player = null
		Sound.death()
		queue_free()


# zpracovani pohybu hrace
func moveProcess(delta):
	# gravitace
	move.y += min(gravity * delta, 1600);
	
	# ovladani postavy (jen pokud stoji na zemi)
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
				Sound.jump()
				
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
				get_parent().add_child(bullet)
				bullet.init(not $AnimatedSprite.flip_h)
				if $AnimatedSprite.flip_h:
					bullet.position = $shot_left.global_position
					$AnimatedSprite.offset.x -= 10
				else:
					bullet.position = $shot_right.global_position
					$AnimatedSprite.offset.x += 10
				noActionMode()
				key_down = true
				Sound.shot()
			
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
	

# zpravovani castic
var last_y = 0
func particleProcess(delta):
	# castice pri pohybu hrace
	if is_on_floor():
		if move.x != 0:
			$Particles2D_run.emitting = true
			if move.x > 0:
				$Particles2D_run.process_material.direction.x = -1
			else:
				$Particles2D_run.process_material.direction.x = 1
		else:
			$Particles2D_run.emitting = false
	else:
		$Particles2D_run.emitting = false
		

func noActionMode():
	no_action = true


# (EVENT) po dokonceni animace navrat zpet do pohyboveho modu
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
	

# nepritel tuto proceduro zavola pokud hraci udeluje poskozeni
var explosion = preload("res://entity/fx/blood_hit.tscn")
func hit(damage):
	# ubere hraci zivoty
	lives -= damage
	# exploze
	var ex = explosion.instance()
	get_parent().add_child(ex)
	ex.init(position, 40, 250, 6, 0.3, 0.2)
