extends Node

# nahradni kurzor mysi
var arrow = load("res://assets/sword_arrow.png")

# fyzika aktivovana / deaktivovana
export var physics_enabled = true

# konec hry
export var game_over = false

# ukazatel na instanci aktualniho hrace
var current_player = null

# save hrace
var player_save = load("save.gd").new()

# true -> prejde do dalsiho levelu
var next_level_request = false

# aktualni nazev sveta
var current_world_name = ""
