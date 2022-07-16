extends Node2D


var slide_in = false


func _on_Timer_timeout():
	if slide_in:
		$AnimationPlayer.play("slide in")
	else:
		$AnimationPlayer.play("slide out")	
	slide_in = not slide_in
