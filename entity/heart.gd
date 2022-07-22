extends Node2D

export var hp_bonus = 10

var value = 0
var last_v = 0
const speed = 3
var efx = preload("res://entity/fx/explosion.tscn").instance()


func _physics_process(delta):
	# animace
	value += delta * speed
	var v = sin(value) * 4
	$Sprite.offset.y = v
	if last_v < v and v < 0:
		if v >= -0.2:
			value = 0
	last_v = v
	
	if GameConfig.current_player != null:
		if GameConfig.current_player.position.distance_to(position) < 45:
			GameConfig.current_player.lives += hp_bonus
			get_parent().add_child(efx)
			efx.init(position, Color.red, 90, 200, 4, 0.2, 0.1)
			Sound.heartTake()
			queue_free()	
			
# nastavi pocet pridanych hp
func setHPBonus(hp):
	hp_bonus = hp
