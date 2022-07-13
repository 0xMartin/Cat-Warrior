extends Node2D


func _physics_process(delta):
	if Input.is_action_pressed("esc"):
		get_parent().showMain()
		

func playAnimation():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("New Anim")


func _on_AnimationPlayer_animation_finished(anim_name):
	print("end")
