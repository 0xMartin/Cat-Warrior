extends KinematicBody2D


export var gravity = 1000
export var lives = 8
export var damage = 25
export var speed = 90


var move = Vector2()
var sleeping = true
var rng = RandomNumberGenerator.new()
var hp_tag_scene = preload("res://entity/hp_damage.tscn")

var fx_scene = preload("res://entity/fx/fountain_fx.tscn")	
var fx2_scene = preload("res://entity/fx/explosion.tscn")

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
			pass
		1:
			pass
		2:
			pass
		3:
			pass
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
	$boss_hp_bar.setLives(lives)


# spusti animaci smrti po zabiti entity
func _on_AnimatedSprite_animation_finished():
	if lives <= 0:
		if $AnimatedSprite.animation == "death":
			var fx = fx_scene.instance()
			get_parent().add_child(fx)
			fx.init($Position2D.global_position, Color.black, 300, 400, 13, 1, 4)
			$AnimationPlayer.play("death")


# utok na hrace
func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation != "attack":
		return
	if $AnimatedSprite.frame != 4 and $AnimatedSprite.frame != 8:
		return
		
	if GameConfig.current_player != null and GameConfig.physics_enabled:
		Sound.hit2()
		GameConfig.current_player.hit(damage)	


# aktuvuje se po provedeni animace smrti
func _on_AnimationPlayer_animation_finished(anim_name):
	var fx = fx2_scene.instance()
	get_parent().add_child(fx)
	fx.init($Position2D.global_position, Color.black, 400, 400, 13, 0.9, 0.15)
	queue_free()
