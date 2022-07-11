extends Node2D

export var speed = 100

var selected = -1

func _physics_process(delta):
	$Camera2D.position.x += speed * delta

func _on_new_game_mouse_entered():
	selected = 0
	$CanvasLayer/new_game.set_self_modulate(Color.red)
	print(">>>")

func _on_new_game_mouse_exited():
	selected = -1
	$CanvasLayer/new_game.set_self_modulate(Color.white)

func _on_load_game_mouse_entered():
	selected = 1

func _on_load_game_mouse_exited():
	selected = -1

func _on_about_mouse_entered():
	selected = 2

func _on_about_mouse_exited():
	selected = -1

func _on_quit_mouse_entered():
	selected = 3

func _on_quit_mouse_exited():
	selected = -1
