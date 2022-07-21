extends Area2D


export var damage = 10
var target = null


func _on_fire_body_entered(body):
	if not body.is_in_group("fire_resist"):
		target = body
		$Timer.start()


func _on_fire_body_exited(body):
	$Timer.stop()


func _on_Timer_timeout():
	if target.has_method("hit"):
		Sound.firehit()
		target.hit(damage)

