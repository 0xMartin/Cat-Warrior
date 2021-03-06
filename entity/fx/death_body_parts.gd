extends Node2D


var rng = RandomNumberGenerator.new()

export var x_power = 300
export var y_max = 320
export var y_min = 180

func _ready():
	rng.randomize()
	$Rigid_Skull.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Bones.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Bones2.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Meat.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Meat2.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Meat3.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Bones3.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Meat4.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	$Rigid_Bones4.apply_impulse(
		Vector2(), 
		Vector2(rng.randi_range(-x_power, x_power), rng.randi_range(-y_min, -y_max))
		)
	Sound.deathBody()
	$AnimationPlayer.play("Visibility_animation")


func _on_Timer_timeout():
	$Particles2D.emitting = false


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
