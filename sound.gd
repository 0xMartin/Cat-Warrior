extends Node2D


func hit():
	$Hit.play()
	
	
func death():
	$Death.play()


func jump():
	$Jump.play()
	

func shot():
	$Shot.play()


func checkpoint():
	$Checkpoint.play()
