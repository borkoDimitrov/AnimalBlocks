extends RayCast2D

var enableDetector = true

func DetectBlocks():
	$Timer.start()

func _on_Timer_timeout():
	if get_collider() == null and IsDetectorActive():
		get_tree().call_group("tiles", "SlideLeft", position.x)
		
func IsDetectorActive() -> bool:
	return enableDetector
	
func DisableDetector():
	enableDetector = false
	
func EnableDetector():
	enableDetector = true
	
func GetCurrentTilesCount() -> int:
	var count = 0
	
	while is_colliding():
		count += 1
		add_exception(get_collider())
		force_raycast_update()
		
	clear_exceptions()
	
	return count
		
