extends RigidBody2D

func _on_TileDestroyer_body_entered(body):
	body.DestroyBlock()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
