extends Area2D


export var speed = 600
export var damage = 0

var move = Vector2()
var run = false
var right = false
var explosion = preload("res://entity/fx/explosion.tscn").instance()


# _right -> smer
# _damage -> poskozeni
# wait_time -> cas kdy ceka nez zasahne (pokud uder ma byt udelen opozdene po aktivovani utoku z blizka)
func init(_right, _damage, wait_time):
	right = _right
	damage = _damage
	$TimerStart.wait_time = wait_time
	$TimerStart.start()
	if not right:
		speed *= -1


func _physics_process(delta):
	if not GameConfig.physics_enabled or not run:
		return	
	position.x += speed * delta


# kolize
func _on_short_hit_body_entered(body):
	if body.is_in_group("hit_enabled"):
		hit()
		if body.has_method("hit"):
			body.hit(damage)


# zasah: destruktor + exploze
func hit():
	Sound.hit3()
	# exploze
	get_parent().add_child(explosion)
	explosion.init(position, Color.darkgray, 50, 400, 6, 0.2, 0.1)
	#destruktor
	queue_free()


# kill po urcite dobe
func _on_TimerEnd_timeout():
	queue_free()


func _on_TimerStart_timeout():
	run = true
	$TimerEnd.start()
