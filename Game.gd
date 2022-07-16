extends Node2D

var player_scene = preload("res://entity/player/Player.tscn")

var world1_scene = preload("res://world/World1.tscn")

var in_game_menu = preload("res://menu/section/in_game_menu.tscn").instance()
var game_over_menu = preload("res://menu/section/game_over_menu.tscn").instance()

var current_world = null
var in_game_menu_visible = false
var esc_holder = true


func _physics_process(delta):
	# hrace zemrel (zobrazi game over menu)
	if GameConfig.current_player == null:
		if not GameConfig.game_over:
			GameConfig.physics_enabled = false
			GameConfig.game_over = true
			remove_child(in_game_menu)
			add_child(game_over_menu)
			Sound.death()
		
	# zobrazeni/skryje in game menu
	if Input.is_action_pressed("esc"):
		if esc_holder:
			esc_holder = false
			if in_game_menu_visible:
				hideInGameMenu()
				in_game_menu_visible = false
			else:
				GameConfig.physics_enabled = false
				add_child(in_game_menu);
				in_game_menu_visible = true
	else:
		esc_holder = true
			

# nacte jiny svet podle indexu (0, 1, ... n)
func loadWorld(index):
	if index == 0:
		# vytvori instanci sveta a pridaho do nadrazene sceny "Main"
		current_world = world1_scene.instance()
		add_child(current_world)
	
	
# nastavi hraci novou pozici ve svete. index (0, 1, ... n) odpovida urcitemu spawnpointu v urcitem svete
# pokud hrac zeprel spawne ho znovu
func setPlayerPosition(spawnpoint_index):
	# musi byt naloadovany nejaky svet
	if current_world == null:
		return
	# podle indexu spawnpoint navrati svet nejakou pozici ve svete
	var position = current_world.getSpawn(spawnpoint_index)
	# pokud hrac neexsituje vytvori noveho
	if GameConfig.current_player == null:
		GameConfig.current_player = player_scene.instance()
		add_child(GameConfig.current_player)
	# hraci nastavi pozici ve svete
	if position != null:
		GameConfig.current_player.position = position
	
		
# skryje in game menu
func hideInGameMenu():
	# skryje menu a povoli fyziku
	GameConfig.physics_enabled = true
	remove_child(in_game_menu)
	
	
# skryje game over menu
func hideGameOverMenu():
	# skryje menu a povoli fyziku
	GameConfig.physics_enabled = true
	GameConfig.game_over = false
	remove_child(game_over_menu)
		
		
# navrat zpet do menu (ukoncit hru)
func quitGame():
	# ulozi save
	storeSave(GameConfig.player_save)
	# odstrani aktualniho hrace a svet
	if GameConfig.current_player != null:
		GameConfig.current_player.queue_free()
		GameConfig.current_player = null
	if current_world != null:
		current_world.queue_free()
		current_world = null
	# skryje in game menu
	hideInGameMenu()
	# skryje game over menu
	hideGameOverMenu()
	# Main -> pozadavek na zobrazeni menu
	get_parent().showMenu()

func storeSave(player_save):
	var file = File.new()
	file.open("save/" + player_save.player_name, File.WRITE)
	var data = {
		"player_name": player_save.player_name,
		"world_index": player_save.world_index,
		"spawnpoint_index": player_save.spawnpoint_index
	}
	file.store_var(data)
	file.close()
