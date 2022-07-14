extends Node2D


# pos - pozice krve
# amout - pocet castic
# size - velikost castic
# velocity - rychlost
# lifetime - delka zivota castic
# time - delka zivota exploze
func init(pos, amount, velocity, size, lifetime, time):
	position.x = pos.x
	position.y = pos.y
	$Particles2D.emitting = true
	$Timer.wait_time = time
	$Timer_death.wait_time = int(1.5 * lifetime)
	$Timer.start()
	$Particles2D.amount = amount
	$Particles2D.process_material.scale = size
	$Particles2D.process_material.initial_velocity = velocity
	$Particles2D.lifetime = lifetime


# zastaveni krve + spusteni timeru na volani destruktoru
func _on_Timer_timeout():
	$Particles2D.emitting = false
	$Timer_death.start()


# zavola destruktor
func _on_Timer_death_timeout():
	queue_free()
