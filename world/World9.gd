extends Node2D


func _ready():
	$door2.hide()
	

# navrati spawnpoint pro tento svet
func getSpawn(index):
	match index:
		0:
			return $spawn0.position
		1:
			return $checkpoint1.position
		2:
			return $checkpoint2.position
		3:
			return $checkpoint3.position
	return null


func getName():
	return "Brana"
	
	
var fx_scene = preload("res://entity/fx/fountain_fx.tscn")	
	
func _physics_process(delta):
	# spusteni boss zapasu
	if GameConfig.current_player != null:
		if weakref($guardian).get_ref():
			# privola bossa
			if not $guardian.visible:
				if GameConfig.current_player.position.distance_to($BossBattleSensor.position) < 200:
					# zobrazi bossa
					$guardian.show()
					# zamce dvere
					$door2.show()
					var fx = fx_scene.instance()
					add_child(fx)
					var p = $door2.position
					p.y += 100
					fx.init(p, Color.darkgray, 300, 400, 8, 1, 0.5)
					# zmeni hudbu
					$AudioStreamPlayer.stop()
					$AudioStreamPlayerBoss.play()
		else:
			# boss byl porazen => otevre cestu dal
			print("finish")
