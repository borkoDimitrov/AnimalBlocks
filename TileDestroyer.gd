extends RigidBody2D

func _ready():
	get_tree().call_group("tiles", "DisableBlockButton")
	get_tree().call_group("detectors", "DisableDetector")

func _on_TileDestroyer_body_entered(body):
	body.DestroyBlock()

func _on_VisibilityNotifier2D_screen_exited():
	get_tree().call_group("tiles", "EnableBlockButton")
	get_tree().call_group("detectors", "DetectBlocks")
	get_tree().call_group("detectors", "EnableDetector")
	queue_free()
