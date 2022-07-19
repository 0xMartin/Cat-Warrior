extends Node2D


var lives = 0
var max_lives = 0


func init(_lives, _boss_name):
	lives = _lives
	max_lives = _lives
	$CanvasLayer/Outline/label1.text = _boss_name	
	

var show = true
func show():
	if show:
		show = false
		visible = true
		$AnimationPlayer.play("show")
		
	
func setLives(_lives):
	lives = max(0, _lives)
	$CanvasLayer/Outline/HPBar.rect_scale.x = float(_lives) / max_lives;
	if lives <= 0:
		$AnimationPlayer.play("hide")


func _on_AnimationPlayer_animation_finished(anim_name):
	if $AnimationPlayer.current_animation == "hide":
		queue_free()
