extends Node2D

var menu_scene = preload("res://Menu.tscn")
var game_scene = preload("res://Game.tscn")

var menu = menu_scene.instance()
var game = game_scene.instance()

func _ready():
	# zobrazi hlavni menu
	add_child(menu)

# zobarazi menu
func showMenu():
	remove_child(game)
	add_child(menu)

# zobrazi hru
func showGame():
	remove_child(menu)
	add_child(game)
