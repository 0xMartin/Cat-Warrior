extends Area2D

export var speed = 400
export var damage = 8

var move = Vector2()
var right = false
var particles = preload("res://entity/fx/bullet_particles.tscn").instance()
var explosion = preload("res://entity/fx/explosion.tscn").instance()


func init(_right):
	right = _right
	if not right:
		speed *= -1
	else:
		$Sprite.flip_h = true
		
	# spawn particle efektu
	particles.init(self, Color.darkgray, 10, 3, 1)
	get_parent().add_child(particles)


func _physics_process(delta):
	if not GameConfig.physics_enabled:
		return	
	position.x += speed * delta


# po uplinuti definovaneho casu odstrani strelu
func _on_Timer_timeout():
	#destruktor
	particles.kill()
	queue_free()


# kolize
func _on_arrow_body_entered(body):
	if not body.is_in_group("not_hit"):
		hit()
		if body.has_method("hit"):
			body.hit(damage)


# zasah: destruktor + exploze
func hit():
	Sound.hit()
	# exploze
	get_parent().add_child(explosion)
	explosion.init(position, Color.darkgray, 80, 300, 4, 0.2, 0.1)
	#destruktor
	particles.kill()
	queue_free()
