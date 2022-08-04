extends RayCast2D

func DetectBlocks():
	$Timer.start()

func _on_Timer_timeout():
	if get_collider() == null:
		get_tree().call_group("tiles", "SlideLeft", position.x)
