extends Node2D


func _on_continue_pressed():
	get_parent().hideInGameMenu()

func _on_back_pressed():
	get_parent().quitGame()
