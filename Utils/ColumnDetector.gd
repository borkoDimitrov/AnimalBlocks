extends RayCast2D

onready var timer = $Timer

func DetectBlocks():
	$Timer.start()

func _on_Timer_timeout():
	if get_collider() == null:
		get_tree().call_group("tiles", "SlideLeft", position.x)
	
func GetCurrentTilesCount() -> int:
	var count = 0
	
	while is_colliding():
		count += 1
		add_exception(get_collider())
		force_raycast_update()
		
	clear_exceptions()
	
	return count
		
