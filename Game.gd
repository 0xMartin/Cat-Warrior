extends Node2D

func _physics_process(delta):
	if $Player == null:
		print("game over")
