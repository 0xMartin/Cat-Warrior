extends Node2D

export var speed = 100

var main_section = preload("res://menu/section/main_section.tscn").instance()
var new_section = preload("res://menu/section/new_section.tscn").instance()
var load_section = preload("res://menu/section/load_section.tscn").instance()
var about_section = preload("res://menu/section/about_section.tscn").instance()
var credits = preload("res://menu/section/Credits.tscn").instance()


func _ready():
	add_child(main_section)
	
	
func _physics_process(delta):
	$Camera2D.position.x += speed * delta


func showMain():
	$BtnClick.play()
	removeAll()
	add_child(main_section)
	
	
func showNew():
	$BtnClick.play()
	removeAll()
	add_child(new_section)


func showLoad():
	$BtnClick.play()
	removeAll()
	add_child(load_section)
	load_section.show()
	
	
func showAbout():
	$BtnClick.play()
	removeAll()
	add_child(about_section)
	
	
func showCredits():
	$BtnClick.play()
	removeAll()
	add_child(credits)
	credits.playAnimation()
	credits.setEndCallBack(funcref(self, "showMain"))
	
	
func removeAll():
	remove_child(main_section)
	remove_child(new_section)
	remove_child(load_section)
	remove_child(about_section)
	remove_child(credits)
	
	
func playGame(player_name):
	get_parent().createNewGame(player_name)
	
	
func loadGame(save_file_path):
	get_parent().loadGame(save_file_path)
	
