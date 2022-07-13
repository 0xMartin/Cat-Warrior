extends Sprite

var value = 0
var last_v = 0

export var speed = 2

func _physics_process(delta):
	value += delta * speed
	var v = sin(value) * 2
	offset.y = v
	
	if last_v < v and v < 0:
		if v >= -0.2:
			value = 0
	last_v = v
