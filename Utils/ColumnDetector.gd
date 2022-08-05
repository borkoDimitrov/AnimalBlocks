extends RayCast2D

func DetectBlocks():
	$Timer.start()

func _on_Timer_timeout():
	if get_collider() == null:
		get_tree().call_group("tiles", "SlideLeft", position.x)

func GetCurrentTilesCount() -> int:
	var colliders = []
	
	while is_colliding():
		var obj = get_collider()
		colliders.append(obj)
		add_exception(obj)
		force_raycast_update()
		
	var size = colliders.size()
	for coll in colliders:
		remove_exception(coll)
		
	return size
		
