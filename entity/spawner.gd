extends Node2D


# entita, kterou bude spawner spawnovat
export var entity = ""
var entity_scene = null

# maximalni pocet entit
export var max_count = 4

# maximalni vzdalenost od spawnu
export var max_dist = 200

# pocet zivotu
export var lives = 100


# aktualni pocet
var cnt = 0

# entity
var entity_list = []


var rng = RandomNumberGenerator.new()
var explosion = preload("res://entity/fx/explosion.tscn")


func _ready():
	entity_scene = load(entity)
	$health_bar.init(lives)
	

func _on_Timer_timeout():
	if not GameConfig.physics_enabled:
		return
	rng.randomize()
	# obnovi pocet entit
	var to_remove = []
	for j in range(entity_list.size()):
		if not weakref(entity_list[j]).get_ref():
			to_remove.append(j)
			cnt = cnt - 1
	for j in to_remove:
		entity_list.remove(j)
	# pokusi spawnout novou entitu
	spawnEntity(rng.randi_range(-max_dist, max_dist))


func spawnEntity(dist):
	if cnt >= max_count:
		return
	var parent = get_parent()
	
	var ent = entity_scene.instance()
	entity_list.append(ent)
	ent.position.x = position.x + dist
	ent.position.y = position.y + 50
	parent.add_child(ent)
	cnt = cnt + 1
	
	# exploze
	var ex = explosion.instance()
	parent.add_child(ex)
	ex.init(ent.position, Color.dodgerblue, 180, 300, 6, 0.3, 0.1)
	
	
func hit(damage):
	lives = max(0, lives - damage)
	$health_bar.setLive(lives)
	if lives <= 0:
		Sound.explosion()
		var ex = explosion.instance()
		get_parent().add_child(ex)
		ex.init(position, Color.dodgerblue, 400, 300, 8, 0.35, 0.2)
		queue_free()


func _on_TimerInit_timeout():
	for i in range(max_count):
		spawnEntity(rng.randi_range(-max_dist, max_dist))	
