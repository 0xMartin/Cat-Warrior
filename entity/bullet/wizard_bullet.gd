extends Area2D


export var speed = 600
export var damage = 5

var move = Vector2()
var right = false
var bullet_owner = null
var particles = preload("res://entity/fx/bullet_particles.tscn").instance()
var explosion = preload("res://entity/fx/explosion.tscn").instance()


func init(_bullet_owner, _right, _damage):
	bullet_owner = _bullet_owner
	damage = _damage
	right = _right
	if not right:
		speed *= -1
		$AnimatedSprite.flip_h = true
		
	# spawn particle efektu
	particles.init(self, Color.orangered, 30, 4, 1)
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
func _on_wizard_bullet_body_entered(body):
	if bullet_owner != body and not body.is_in_group("not_hit"):
		hit()
		if body.has_method("hit"):
			body.hit(damage)


# zasah: destruktor + exploze
func hit():
	Sound.hit()
	# exploze
	get_parent().add_child(explosion)
	explosion.init(position, Color.orangered, 90, 300, 4, 0.2, 0.1)
	#destruktor
	particles.kill()
	queue_free()

