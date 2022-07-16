extends Node2D

# smer strelby
export var right = true


var arrow_scene = preload("res://entity/bullet/arrow.tscn")

func _ready():
	if right:
		$Sprite_right.visible = true
		$Sprite_left.visible = false
	else:
		$Sprite_right.visible = false
		$Sprite_left.visible = true


func _physics_process(delta):
	var status = false
	if right:
		status = $RayCast2D_right.is_colliding()
	else:
		status = $RayCast2D_left.is_colliding()
	if status:
		if $Timer.time_left == 0:
			shot()
			$Timer.start()
	else:
		$Timer.stop()


# automaticka strelba
func _on_Timer_timeout():
	shot()
	
	
# vystrel
func shot():
	var arrow = arrow_scene.instance()
	if right:
		arrow.position = $Position2D_right.global_position
	else:
		arrow.position = $Position2D_left.global_position
	get_parent().add_child(arrow)
	arrow.init(right)
	Sound.shot()
