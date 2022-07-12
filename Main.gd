extends Node2D

var menu = preload("res://menu/Menu.tscn").instance()
var game = preload("res://Game.tscn").instance()

var arrow = load("res://assets/sword_arrow.png")


func _ready():
	# zobrazi hlavni menu
	add_child(menu)
	# zmeni kurzor
	Input.set_custom_mouse_cursor(arrow)

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
	
# nastavi svet a spawnpoint hrace
func setWorld():
	game.loadWorld(GameConfig.player_save.world_index)
	game.setPlayerPosition(GameConfig.player_save.spawnpoint_index)
