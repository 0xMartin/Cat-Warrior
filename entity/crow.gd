extends KinematicBody2D


export var speed = 700
export var lives = 20
export var damage = 4


var move = Vector2()
var rng = RandomNumberGenerator.new()
var death = preload("res://entity/fx/death_body_parts.tscn")


func _ready():
	$health_bar.init(lives)
	
	
func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return
	
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


func actions(delta):
	pass


func hit(damage):
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)


func _on_AttackTimer_timeout():
	if GameConfig.current_player != null and GameConfig.physics_enabled:
		Sound.hit2()
		GameConfig.current_player.hit(damage)	
