extends Label

func _physics_process(delta):
	if $"../../Player" != null:
		text = str($"../../Player".lives) + " hp"
