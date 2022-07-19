extends Node2D


const speed = 100


func init(_position, hp):
	self.position = _position
	$label.text = "- " + str(hp) + " hp" 
	$AnimationPlayer.play("hide")


func _physics_process(delta):
	position.y += speed * delta


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
