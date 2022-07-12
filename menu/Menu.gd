extends Node2D

export var speed = 100

var main_section = preload("res://menu/section/main_section.tscn").instance()
var new_section = preload("res://menu/section/new_section.tscn").instance()
var load_section = preload("res://menu/section/load_section.tscn").instance()
var about_section = preload("res://menu/section/about_section.tscn").instance()

func _ready():
	add_child(main_section)
	
func _physics_process(delta):
	$Camera2D.position.x += speed * delta

func showMain():
	print("main")
	removeAll()
	add_child(main_section)
	
func showNew():
	print("new")	
	removeAll()
	add_child(new_section)

func showLoad():
	print("load")
	removeAll()
	add_child(load_section)
	load_section.show()
	
func showAbout():
	print("about")
	removeAll()
	add_child(about_section)
	
func removeAll():
	remove_child(main_section)
	remove_child(new_section)
	remove_child(load_section)
	remove_child(about_section)
	
func playGame(player_name):
	get_parent().createNewGame(player_name)
	
func loadGame(save_file_path):
	get_parent().loadGame(save_file_path)

