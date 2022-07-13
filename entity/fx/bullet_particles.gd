extends Node2D

var bullet = null

func init(_bullet, color, amount, size, lifetime):
	bullet = _bullet
	$Particles2D.emitting = true
	$Timer.wait_time = int(lifetime * 1.5)
	$Particles2D.amount = amount
	$Particles2D.process_material.scale = size
	$Particles2D.lifetime = lifetime
	$Particles2D.process_material.color = color


func _physics_process(delta):
	if bullet != null:
		position.x = bullet.position.x
		position.y = bullet.position.y


# odstrani castice po strele
func kill():
	bullet = null
	$Particles2D.emitting = false
	$Timer.start()


func _on_Timer_timeout():
	queue_free() 
