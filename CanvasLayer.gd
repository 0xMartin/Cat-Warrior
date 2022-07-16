extends CanvasLayer

func _physics_process(delta):
	if $"../Player" != null:
		$Label_lives.text = str($"../Player".lives) + " hp"
		$Label_level.text = str(GameConfig.player_save.world_index) + " - " + GameConfig.current_world_name
		$Label_name.text = str(GameConfig.player_save.player_name)
