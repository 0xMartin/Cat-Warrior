extends CanvasLayer

func _physics_process(delta):
	if $"../Player" != null:
		# zakladni info
		$Label_lives.text = str($"../Player".lives) + " hp"
		$Label_level.text = str(GameConfig.player_save.world_index) + " - " + GameConfig.current_world_name
		$Label_name.text = str(GameConfig.player_save.player_name)
		
		 # boosty
		var labels = [$Label4, $Label5]
		var values = [$Label_boost_time1, $Label_boost_time2]
		var i = -1
		if GameConfig.current_player.power_boost_time > 0:
			i += 1
			labels[i].text = "Sila:"
			labels[i].visible = true
			values[i].text = str(GameConfig.current_player.power_boost_time) + " s"
			values[i].visible = true
		if GameConfig.current_player.defense_boost_time > 0:
			i += 1
			labels[i].text = "Obrana:"
			labels[i].visible = true
			values[i].text = str(GameConfig.current_player.defense_boost_time) + " s"
			values[i].visible = true
		match i:
			-1:
				$Label4.visible = false
				$Label_boost_time1.visible = false
				$Label5.visible = false
				$Label_boost_time2.visible = false
			0:
				$Label5.visible = false
				$Label_boost_time2.visible = false	
		
