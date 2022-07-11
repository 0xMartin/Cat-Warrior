extends Label

func _physics_process(delta):
	if $"../../Player" != null:
		text = "Zivoty: " + str($"../../Player".lives) + " hp"
