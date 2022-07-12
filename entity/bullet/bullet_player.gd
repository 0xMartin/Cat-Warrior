extends Area2D

export var speed = 600

var move = Vector2()
var right = false

func init(_right):
	right = _right
	if not right:
		speed *= -1
		$Sprite.flip_h = true

func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return	
	position.x += speed * delta

# po uplinuti definovaneho casu odstrani strelu
func _on_Timer_timeout():
	queue_free()


func _on_bullet_player_area_entered(area):
	pass
