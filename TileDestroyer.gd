extends RigidBody2D

func _on_TileDestroyer_body_entered(body):
	body.DestroyBlock()

func _on_VisibilityNotifier2D_screen_exited():
	get_tree().call_group("tiles", "EnableBlockButton")
	queue_free()
