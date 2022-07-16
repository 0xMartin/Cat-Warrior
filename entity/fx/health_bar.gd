extends Node2D


var max_lives = 0


func init(_max_lives):
	max_lives = _max_lives
	visible = false


func setLive(live):
	if live <= 0:
		visible = false
	else:
		visible = true
	$Timer.start()
	$SpriteRed.scale.x = float(live) / max_lives


func _on_Timer_timeout():
	visible = false
