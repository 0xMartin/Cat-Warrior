extends KinematicBody2D


export var gravity = 1000
const max_lives = 900
export var lives = max_lives
export var damage = 30
export var speed = 90


var move = Vector2()
var sleeping = true
var rng = RandomNumberGenerator.new()
var hp_tag_scene = preload("res://entity/hp_damage.tscn")

var fx_scene = preload("res://entity/fx/fountain_fx.tscn")	
var fx2_scene = preload("res://entity/fx/explosion.tscn")
var bullet_scene = preload("res://entity/bullet/guardian_bullet.tscn")	


func _ready():
	$boss_hp_bar.init(lives, "Guardian")


func show():
	$boss_hp_bar.show()
	self.visible = true

func _physics_process(delta):
	if not GameConfig.physics_enabled or not visible:
		return
	
	if lives > 0 and position.y < 1000:
		# gravitace
		move.y += min(gravity * delta, 1600);
		# akce
		actions(delta)
		# pridani hp pokud boss zabije hrace
		hpAdd()
	else:
		# smrt
		move.x = 0
		move.y = 0
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play("death")

	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))


var state = 0
var waiting = 200
func actions(delta):
	# vypocet vzdalenosti od hrace ...
	var dist = 9999
	var x_dir = 0
	if GameConfig.current_player != null:
		dist = GameConfig.current_player.position.distance_to(position)
		x_dir = GameConfig.current_player.position.x - position.x

	# orientace vzdy smerem k hraci
	if x_dir > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	# stavy
	match state:
		0:
			# jde smerem k hraci
			$AnimatedSprite.play("walk")
			if x_dir > 0:
				move.x = speed
			else:
				move.x = - speed
			# prechod do utoku
			if dist < 100:
				state = 1
			# prechod na specialni utok
			if waiting <= 0:
				waiting = 100
				state = 2
		1:
			# utok
			if dist > 100:
				state = 0
			$AnimatedSprite.play("attack")
			# prechod na specialni utok
			if waiting <= 0:
				waiting = 100
				state = 2
		2:
			# specialni utok
			$AnimatedSprite.play("idle")
			move.x = 0
			if waiting <= 0:
				# provede utok
				var p = get_parent()
				
				#zvuk 
				$AudioStreamPlayerAttack.play()
				
				# bullet right
				var b = bullet_scene.instance()
				p.add_child(b)
				b.init($Position2DShot.global_position, true)
				
				# bullet left
				b = bullet_scene.instance()
				p.add_child(b)
				b.init($Position2DShot.global_position, false)
				
				# fx
				var fx = fx2_scene.instance()
				p.add_child(fx)
				fx.init(position, Color.black, 300, 400, 7, 0.7, 0.15)
				
				# dalsi stav
				waiting = rng.randi_range(300, 1200)
				state = 0
			
	waiting -= 1	
	
	
var hp_added = false
func hpAdd():
	if GameConfig.current_player != null:
		# test jestli hrac bude zabit
		if GameConfig.current_player.lives <= 0:
			if not hp_added:
				hp_added = true
				lives = min(lives + 100, max_lives)
				$boss_hp_bar.setLives(lives)
		else:
			hp_added = false
		
		
# zasah
func hit(damage):
	# hp tag
	if lives > 0:
		var parent = get_parent()
		var hp_tag = hp_tag_scene.instance()
		hp_tag.init(position, damage)
		parent.add_child(hp_tag)
		
	lives = max(0, lives - damage)
	$boss_hp_bar.setLives(lives)


# spusti animaci smrti po zabiti entity
func _on_AnimatedSprite_animation_finished():
	if lives <= 0:
		if $AnimatedSprite.animation == "death":
			var fx = fx_scene.instance()
			get_parent().add_child(fx)
			fx.init($Position2D.global_position, Color.black, 300, 400, 13, 1, 4)
			$AudioStreamPlayer.play()
			$AnimationPlayer.play("death")
			if GameConfig.current_player != null:
				GameConfig.current_player.shakeWithCamera(4, 5)	


# utok na hrace
func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation != "attack":
		return
	if $AnimatedSprite.frame != 2:
		return
		
	if GameConfig.current_player != null and GameConfig.physics_enabled:
		# hit
		Sound.hit2()
		GameConfig.current_player.hit(damage)	


# aktuvuje se po provedeni animace smrti
func _on_AnimationPlayer_animation_finished(anim_name):
	var fx = fx2_scene.instance()
	get_parent().add_child(fx)
	fx.init($Position2D.global_position, Color.black, 400, 400, 13, 0.9, 0.15)
	Sound.explosion()
	GameConfig.current_player.shakeWithCamera(1, 12)
	queue_free()
