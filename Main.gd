extends Node2D

var menu_scene = preload("res://menu/Menu.tscn")
var game_scene = preload("res://Game.tscn")

var menu = menu_scene.instance()
var game = game_scene.instance()

var arrow = load("res://assets/sword_arrow.png")

func _ready():
	# zobrazi hlavni menu
	add_child(menu)
	
	# zmeni kurzor
	Input.set_custom_mouse_cursor(arrow)

# zobarazi menu
func showMenu():
	remove_child(game)
	add_child(menu)

# zobrazi hru
func showGame():
	remove_child(menu)
	add_child(game)
