extends Control

func _on_NormalGame_pressed():
	Globals.type_of_game = "normal_game"
	get_tree().change_scene("res://LevelManager.tscn")

func _on_RandomGame_pressed():
	Globals.random_game = true
	Globals.type_of_game = "normal_game"
	get_tree().change_scene("res://LevelManager.tscn")

func _on_Classic_pressed():
	Globals.type_of_game = "classic_game"
	get_tree().change_scene("res://LevelManager.tscn")

func _on_Count_pressed():
	Globals.type_of_game = "count_game"
	get_tree().change_scene("res://LevelManager.tscn")

func _on_MatchMore_pressed():
	Globals.type_of_game = "match_game"
	get_tree().change_scene("res://LevelManager.tscn")

func _on_Exit_pressed():
	get_tree().quit()

