extends StaticBody2D


export var lives = 100
var fx = preload("res://entity/fx/fountain_fx.tscn").instance()
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
		parent.add_child(fx)
		var p = position
		p.y += 100
		fx.init(p, Color.dimgray, 300, 400, 8, 1, 0.5)
		queue_free()


func hide():
	visible = false
	$CollisionShape2D.disabled = true


func show():
	visible = true
	$CollisionShape2D.disabled = false
