extends Sprite

var value = 0
var last_v = 0
var mouse_on = false

var ig_icon = load("res://assets/ig_icon.png")
export var speed = 2

func _physics_process(delta):
	# animace
	value += delta * speed
	var v = sin(value) * 2
	offset.y = v
	
	if last_v < v and v < 0:
		if v >= -0.2:
			value = 0
	last_v = v
	
	# open lik
	if mouse_on:
		if Input.is_action_pressed("player_shot"):
			OS.shell_open("https://www.instagram.com/cat.zori/")
			mouse_on = false


func _on_Control_mouse_entered():
	mouse_on = true
	$CanvasModulate.color = Color(1.0, 1.0, 0.62)
	Input.set_custom_mouse_cursor(ig_icon)


func _on_Control_mouse_exited():
	mouse_on = false
	$CanvasModulate.color = Color(1.0, 1.0, 1.0)
	Input.set_custom_mouse_cursor(GameConfig.arrow)
