extends Node2D


func _on_new_game_pressed():
	get_parent().showNew()

func _on_load_game_pressed():
	get_parent().showLoad()

func _on_about_pressed():
	get_parent().showAbout()

func _on_exit_pressed():
	get_tree().quit()
