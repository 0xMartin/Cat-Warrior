extends StaticBody2D


export var lives = 100
var explosion = preload("res://entity/fx/explosion.tscn").instance()


func _ready():
	$health_bar.init(lives)
	
func hit(damage):
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)
	if lives <= 0:
		get_parent().add_child(explosion)
		explosion.init(position, Color.darkgoldenrod, 300, 300, 7, 0.3, 0.1)
		queue_free()
