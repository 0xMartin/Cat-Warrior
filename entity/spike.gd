extends Area2D


export var damage = 150


# odebere entite hp jen pokud skoci na spike
func _on_spike_body_entered(body):
	if body.has_method("hit"):
		if body.has_method("is_on_floor"):
			if not body.is_on_floor():
				body.hit(damage)
