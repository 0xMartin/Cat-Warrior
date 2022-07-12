extends Node2D


func _on_respawn_pressed():
	var parent = get_parent()
	parent.hideGameOverMenu()
	var save = parent.getSave()
	if save != null:
		parent.setPlayerPosition(save.spawnpoint_index)
	else:
		parent.setPlayerPosition(0)

func _on_back_pressed():
	get_parent().quitGame()
