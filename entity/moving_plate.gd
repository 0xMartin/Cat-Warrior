extends Node2D


var slide_in = false

export var right = true


func _ready():
	if right:
		$Sprite_left.visible = false
		$Sprite_right.visible = true
	else:
		$Sprite_left.visible = true
		$Sprite_right.visible = false


func _on_Timer_timeout():
	if slide_in:
		$AnimationPlayer.play("slide in")
	else:
		$AnimationPlayer.play("slide out")	
	slide_in = not slide_in
