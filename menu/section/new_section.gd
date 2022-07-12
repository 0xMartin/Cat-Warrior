extends Node2D


func _on_play_pressed():
	if len($CanvasLayer/TextEdit.text) > 0:
		get_parent().playGame($CanvasLayer/TextEdit.text)	

func _on_back_pressed():
	get_parent().showMain()
