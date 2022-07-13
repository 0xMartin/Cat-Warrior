extends Node2D


func _on_play_pressed():
	if len($CanvasLayer/TextEdit.text) > 0:
		get_parent().playGame($CanvasLayer/TextEdit.text)	


func _on_back_pressed():
	get_parent().showMain()


func _on_TextEdit_text_changed():
	var inputText = $CanvasLayer/TextEdit.get_line(0)
	if inputText.length() > 20:
		$CanvasLayer/TextEdit.set_line(0, inputText.substr(0, 20))
