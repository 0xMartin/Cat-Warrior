extends StaticBody2D


export var lives = 100
var explosion = preload("res://entity/fx/explosion.tscn").instance()
var hp_tag_scene = preload("res://entity/hp_damage.tscn")


func _ready():
	$health_bar.init(lives)
	
func hit(damage):
	# hp tag
	var parent = get_parent()
	if lives > 0:
		var hp_tag = hp_tag_scene.instance()
		hp_tag.init(position, damage)
		parent.add_child(hp_tag)
		
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)
	
	if lives <= 0:
		parent.add_child(explosion)
		explosion.init(position, Color.darkgoldenrod, 300, 300, 7, 0.3, 0.1)
		queue_free()
