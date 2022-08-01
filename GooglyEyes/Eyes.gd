extends StaticBody2D

func _on_BlinkTimer_timeout():
	var blink_chance = randi() % 300
	if blink_chance == 0:
		$AnimationPlayer.play("Blink")
