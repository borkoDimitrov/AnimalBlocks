extends Control

func _on_ClassicGame_pressed():
	get_tree().change_scene("res://LevelManager.tscn")

func _on_Exit_pressed():
	get_tree().quit()
