extends RayCast2D

func Detect():
	$Timer.start()

func _on_Timer_timeout():
	if get_collider() == null:
		get_tree().call_group("tiles", "slide_left", position.x)
