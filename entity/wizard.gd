extends KinematicBody2D


export var gravity = 1000
export var lives = 30
export var damage = 35
const detect_range = 480


var move = Vector2()
var run = false
var rng = RandomNumberGenerator.new()
var hp_tag_scene = preload("res://entity/hp_damage.tscn")
var bullet_scene = preload("res://entity/bullet/wizard_bullet.tscn")


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
		move.x = 0
		move.y = 0
		$CollisionShape2D.disabled = true
		Sound.explosion()
		$AnimatedSprite.play("death")

	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))


var right = false
func actions(delta):
	var dist = 9999
	var x_dir = 0
	if GameConfig.current_player != null:
		dist = GameConfig.current_player.position.distance_to(position)
		x_dir = GameConfig.current_player.position.x - position.x

	# orientace
	if x_dir > 0:
		right = true
		$AnimatedSprite.flip_h = true
	else:
		right = false
		$AnimatedSprite.flip_h = false
		
	# streba / idle
	if dist < detect_range:
		$AnimatedSprite.play("attack")
	else:
		$AnimatedSprite.play("idle")
	

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


# zabije entitu
func _on_AnimatedSprite_animation_finished():
	if lives <= 0:
		if $AnimatedSprite.animation == "death":
			queue_free()


# strelba
func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "attack":
		if $AnimatedSprite.frame == 8:
			var bullet = bullet_scene.instance()
			get_parent().add_child(bullet)
			bullet.init(self, right, damage)
			bullet.position = position
			Sound.shot()
