extends Node

var arrow = load("res://assets/sword_arrow.png")

export var physics_enabled = true

export var game_over = false

var current_player = null

var player_save = load("save.gd").new()
