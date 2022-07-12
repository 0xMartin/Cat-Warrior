extends Node2D


func _on_respawn_pressed():
	var parent = get_parent()
	parent.hideGameOverMenu()
	if GameConfig.player_save != null:
		parent.setPlayerPosition(GameConfig.player_save.spawnpoint_index)
	else:
		parent.setPlayerPosition(0)

func _on_back_pressed():
	get_parent().quitGame()
