extends KinematicBody2D



const gravity = 1000

const lives_stage_1 = 500
const lives_stage_2 = 4000

var lives = lives_stage_1

export var damage_hit = 40
export var damage_shot = 30

export var speed = 100


var move = Vector2()
var run = false
var rng = RandomNumberGenerator.new()
var explosion = preload("res://entity/fx/explosion.tscn").instance()
var hp_tag_scene = preload("res://entity/hp_damage.tscn")


func _ready():
	$boss_hp_bar.init(lives, "Archon")
	$AnimationPlayer.play("fly_fx")


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
		death()

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
	$boss_hp_bar.setLives(lives)
	

# smrt bosse
func death():
	# zvuk
	Sound.explosion()
	# exploze
	get_parent().add_child(explosion)
	explosion.init(position, Color.orange, 300, 400, 8, 0.4, 0.2)
	# zabiti
	queue_free()
