extends RigidBody2D


export var damage = 250


var explosion = preload("res://entity/fx/explosion.tscn").instance()


func hit(damage):
	if $Timer.time_left == 0:
		$Fire.emitting = true
		$Timer.start()


func _physics_process(delta):
	if not GameConfig.physics_enabled:
		$Timer.paused = true 
	else:
		$Timer.paused = false 


func _on_Timer_timeout():
	get_parent().add_child(explosion)
	explosion.init(position, Color.orangered, 750, 900, 8, 0.3, 0.25)
	$Explosion.monitoring = true
	Sound.explosion()
	GameConfig.current_player.shakeWithCamera(0.6, 5)
	visible = false
	$TimerKill.start()


# vsem kteri jsou v zone ubere zivoty
func _on_Explosion_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)


func _on_TimerKill_timeout():
	queue_free()
