extends Node2D


var function = null


func _physics_process(delta):
	if Input.is_action_pressed("esc"):
		get_parent().showMain()
		

func playAnimation():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("New Anim")


func setEndCallBack(_function):
	function = _function


func _on_AnimationPlayer_animation_finished(anim_name):
	if function != null:
		function.call_func()
