extends KinematicBody2D



const gravity = 1000

const lives_stage_1 = 500
const lives_stage_2 = 4000

export var damage_hit = 40
export var damage_shot = 30
export var speed = 70

var stage = 2
var lives = lives_stage_1

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
		match stage:
			1:
				# akce stage 1
				actions_stage_1(delta)
			2:
				# akce stage 2
				actions_stage_2(delta)
	else:
		match stage:
			1:
				# promena na stage 2
				stage = 2
				lives = lives_stage_2
			2:
				# smrt
				death()

	# provedeni pohybu
	move = move_and_slide(move, Vector2(0, -1))


var state = 0
var wait = 0

func actions_stage_1(delta):
	$body/left/AnimatedSprite_body.play("mode1")
	$body/right/AnimatedSprite_body.play("mode1")


func actions_stage_2(delta):
	$body/left/AnimatedSprite_body.play("mode2")
	$body/right/AnimatedSprite_body.play("mode2")
	
	# vypocet vzdalenosti od hrace ...
	var dist = 9999
	var x_dir = 0
	if GameConfig.current_player != null:
		dist = GameConfig.current_player.position.distance_to(position)
		x_dir = GameConfig.current_player.position.x - position.x

	# stavy
	match state:
		0:
			stage2_playSpriteAnimation("idle")
			# jit za hracem
			if x_dir > 0:
				move.x = speed
				turnRight(true)
			else:
				move.x = -speed
				turnRight(false)
			# zasahne hrace mecem pokud je moc blizko
			if dist < 150:
				state = 5
		1: 
			# sleep
			if wait <= 0:
				wait = rng.randf_range(120, 500)
				state = 0
		2:
			# specialni utok 1 (pri zemi)
			pass
		3:
			# specialni utok 2 (ze shora)
			pass
		4: 
			# vystrelit
			pass
		5:
			# utok z blizka
			stage2_playSpriteAnimation("sword")
			if dist > 150:
				state = 0
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
	

var look_on_right = true


# prevrati vsechny sprity
func turnRight(right):
	look_on_right = right
	if right:
		$body/right.visible = true
		$body/left.visible = false
	else:
		$body/right.visible = false
		$body/left.visible = true
		
	
func stage2_playSpriteAnimation(name):
	if look_on_right:
		match name:
			"idle":
				$body/right/AnimatedSprite_gold.visible = false
				$body/right/AnimatedSprite_thunder.visible = false
				$body/right/AnimatedSprite_sword.visible = false
				$body/right/AnimatedSprite_shot.visible = false
			"shot":
				$body/right/AnimatedSprite_gold.visible = false
				$body/right/AnimatedSprite_thunder.visible = false
				$body/right/AnimatedSprite_sword.visible = false
				$body/right/AnimatedSprite_shot.visible = true
			"sword":
				$body/right/AnimatedSprite_gold.visible = false
				$body/right/AnimatedSprite_thunder.visible = false
				$body/right/AnimatedSprite_sword.visible = true
				$body/right/AnimatedSprite_shot.visible = false
			"thunder":
				$body/right/AnimatedSprite_gold.visible = false
				$body/right/AnimatedSprite_thunder.visible = true
				$body/right/AnimatedSprite_thunder.play("run")
				$body/right/AnimatedSprite_sword.visible = false
				$body/right/AnimatedSprite_shot.visible = false
			"gold":
				$body/right/AnimatedSprite_gold.visible = true
				$body/right/AnimatedSprite_gold.play("run")
				$body/right/AnimatedSprite_thunder.visible = false
				$body/right/AnimatedSprite_sword.visible = false
				$body/right/AnimatedSprite_shot.visible = false
	else:
		match name:
			"idle":
				$body/left/AnimatedSprite_gold.visible = false
				$body/left/AnimatedSprite_thunder.visible = false
				$body/left/AnimatedSprite_sword.visible = false
				$body/left/AnimatedSprite_shot.visible = false
			"shot":
				$body/left/AnimatedSprite_gold.visible = false
				$body/left/AnimatedSprite_thunder.visible = false
				$body/left/AnimatedSprite_sword.visible = false
				$body/left/AnimatedSprite_shot.visible = true
			"sword":
				$body/left/AnimatedSprite_gold.visible = false
				$body/left/AnimatedSprite_thunder.visible = false
				$body/left/AnimatedSprite_sword.visible = true
				$body/left/AnimatedSprite_shot.visible = false
			"thunder":
				$body/left/AnimatedSprite_gold.visible = false
				$body/left/AnimatedSprite_thunder.visible = true
				$body/left/AnimatedSprite_thunder.play("run")
				$body/left/AnimatedSprite_sword.visible = false
				$body/left/AnimatedSprite_shot.visible = false
			"gold":
				$body/left/AnimatedSprite_gold.visible = true
				$body/left/AnimatedSprite_gold.play("run")
				$body/left/AnimatedSprite_thunder.visible = false
				$body/left/AnimatedSprite_sword.visible = false
				$body/left/AnimatedSprite_shot.visible = false
