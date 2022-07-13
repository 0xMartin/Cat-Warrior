extends Area2D

export var speed = 600

var move = Vector2()
var right = false
var particles = preload("res://entity/fx/bullet_particles.tscn").instance()
var explosion = preload("res://entity/fx/explosion.tscn").instance()

func init(_right):
	right = _right
	if not right:
		speed *= -1
		$Sprite.flip_h = true
		
	# spawn particle efektu
	particles.init(self, Color.blue, 30, 4, 1)
	get_parent().add_child(particles)


func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return	
	position.x += speed * delta


# po uplinuti definovaneho casu odstrani strelu
func _on_Timer_timeout():
	hit()


# kolize s objektem
func _on_bullet_player_area_entered(area):
	hit()
	

# zasah: destruktor + exploze
func hit():
	# exploze
	get_parent().add_child(explosion)
	explosion.init(position, Color.blue, 90, 300, 4, 0.2, 0.1)
	#destruktor
	particles.kill()
	queue_free()
