extends StaticBody2D

func _on_BlinkTimer_timeout():
	var blink_chance = randi() % 200
	if blink_chance == 0:
		$AnimationPlayer.play("Blink")
