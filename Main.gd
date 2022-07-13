extends Node2D

var menu = preload("res://menu/Menu.tscn").instance()
var game = preload("res://Game.tscn").instance()


func _ready():
	# zobrazi hlavni menu
	add_child(menu)
	# zmeni kurzor
	Input.set_custom_mouse_cursor(GameConfig.arrow)

# zobarazi menu
func showMenu():
	remove_child(game)
	add_child(menu)

# zobrazi hru
func showGame():
	remove_child(menu)
	add_child(game)

# vytvori novou hru
func createNewGame(player_name):
	GameConfig.player_save.player_name = player_name
	GameConfig.player_save.spawnpoint_index = 0
	GameConfig.player_save.world_index = 0
	showGame()
	setWorld()
	
# nacte hru ze savu hrace	
func loadGame(save_file_path):
	var file = File.new()
	file.open(save_file_path, File.READ)
	var data = file.get_var()
	file.close()
	GameConfig.player_save.loadFromJSON(data)
	showGame()
	setWorld()
	
# nastavi svet a spawnpoint hrace podle globalne nacteneho savu hrace
func setWorld():
	game.loadWorld(GameConfig.player_save.world_index)
	game.setPlayerPosition(GameConfig.player_save.spawnpoint_index)
