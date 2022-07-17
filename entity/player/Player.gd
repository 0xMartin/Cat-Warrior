extends KinematicBody2D

# pocet zivotu
export var lives = 100

# sila gravitace
export var gravity = 1000

# rychlost pohybu
export var speed = 200

# intenzita skoku
export var jump = 600

# hit damage
export var damage = 14

# true -> je mozne ovladat postavu
export var enabled = true

# otresy kamery
export var cam_shake = false

# sila otresu kamery
export var cam_shake_power = 2.0


var killed = false
var no_action = false
var move = Vector2()


var bullet_scene = preload("res://entity/bullet/bullet_player.tscn")
var short_hit_scene = preload("res://entity/bullet/short_hit.tscn")
var death = preload("res://entity/fx/death_body_parts.tscn")


func _physics_process(delta):
	if not GameConfig.physics_enabled or killed:
		return

	if cam_shake:
		cameraShakeProcess()
	moveProcess(delta)
	particleProcess(delta)
	
	# smrt: pad dolu nebo ztrata vsech hp
	if (position.y > 1000 or lives <= 0) and not killed:
		killed = true
		$CollisionShape2D.disabled = true
		var d = death.instance()
		d.position = position
		get_parent().add_child(d)
		visible = false
		if position.y > 1000:
			$KillTimer.wait_time = 1
		$KillTimer.start()


# zpracovani otresu kamery
func cameraShakeProcess():
	$Camera2D.set_offset(Vector2(rand_range(-cam_shake_power,
	 cam_shake_power), rand_range(-cam_shake_power, cam_shake_power)))
	

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
				# vytvori instanci utoku z blizka (nevyditelny projektil s kratkym dosahem)
				var hit = short_hit_scene.instance()
				get_parent().add_child(hit)
				hit.init(self, not $AnimatedSprite.flip_h, damage, 0.3)
				hit.position = position
				
			# strelba
			if Input.is_action_pressed("player_shot"):
				$AnimatedSprite.play("shot")
				$AnimatedSprite.offset.y -= 4
				var bullet = bullet_scene.instance()
				get_parent().add_child(bullet)
				bullet.init(self, not $AnimatedSprite.flip_h)
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


# (EVENT) po dokonceni nimace navrat zpet do pohyboveho modu
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
	if killed:
		return
	# ubere hraci zivoty
	lives = max(0, lives - damage)
	# efekt zasahu
	var ex = explosion.instance()
	get_parent().add_child(ex)
	ex.init(position, 40, 250, 6, 0.3, 0.2)
	# zatreseni kamery
	shakeWithCamera(0.5, 2)


# otrese s kamerou urcitou silou po urcitou dobu
func shakeWithCamera(time, power):
	cam_shake_power = power
	cam_shake = true
	$CamShakeTimer.wait_time = time
	$CamShakeTimer.start()

# (EVENT) pro ukonceni treseni kamery
func _on_CamShakeTimer_timeout():
	cam_shake = false
	$Camera2D.set_offset(Vector2(0, 0))


# (EVENT) zabije hrace az se zpozdenim => aby byla videt jeho smrt
func _on_KillTimer_timeout():
	GameConfig.current_player = null
	queue_free()
