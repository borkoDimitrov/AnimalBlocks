extends RigidBody2D

func _on_TileDestroyer_body_entered(body):
	body.DestroyBlock()
