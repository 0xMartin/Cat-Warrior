extends Area2D

export var speed = 600
export var damage = 4

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


# kolize
func _on_bullet_player_body_entered(body):
	if body.is_in_group("hit_enabled"):
		hit()
		if body.has_method("hit"):
			body.hit(damage)


# zasah: destruktor + exploze
func hit():
	# exploze
	get_parent().add_child(explosion)
	explosion.init(position, Color.blue, 90, 300, 4, 0.2, 0.1)
	#destruktor
	particles.kill()
	queue_free()

