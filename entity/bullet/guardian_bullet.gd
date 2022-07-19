extends Node2D

var speed = 400
const damage = 8

func init(_position, right):
	position = _position
	if not right:
		speed *= -1
		
		
func _physics_process(delta):
	if not GameConfig.physics_enabled:
		$Timer.paused = true
		return
	else:
		$Timer.paused = false
		
	# move
	position.x += speed * delta	
	
	# damage
	if GameConfig.current_player != null:
		if GameConfig.current_player.position.distance_to(position) < 75:
			if $TimerHit.time_left == 0:
				hit()
				$TimerHit.start()
	else:
		_on_Timer_timeout()	


func _on_Timer_timeout():
	$TimerHit.stop()
	queue_free()


func _on_TimerHit_timeout():
	hit()
	

func hit():
	if GameConfig.current_player != null and GameConfig.physics_enabled:
		GameConfig.current_player.hit(damage)
		Sound.hit2()
