extends RigidBody2D


export var damage = 150
export var radius = 250


var explosion = preload("res://entity/fx/explosion.tscn").instance()


func hit(damage):
	if $Timer.time_left == 0:
		$Fire.emitting = true
		$Timer.start()


func _on_Timer_timeout():
	get_parent().add_child(explosion)
	explosion.init(position, Color.orangered, 750, 900, 8, 0.3, 0.25)
	Sound.explosion()
	queue_free()
