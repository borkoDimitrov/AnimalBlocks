extends Node

var levelTypeIndex = 0

onready var levels = [
	preload("res://Level/ClassicLevel.tscn"),
	preload("res://Level/LevelTileCount.tscn"),
	preload("res://Level/LevelTileDestroyer.tscn")]

func _ready():
	Globals.connect("HANDLE_LEVEL_WON", self, "HandleLevelWon")
	StartNextLevel()
	
func HandleLevelWon():
	levelTypeIndex += 1
	StartNextLevel()
	
func StartNextLevel():
	var levelDificulty = levelTypeIndex / levels.size()
	var level = levels[levelTypeIndex % levels.size()]
	var level_path = level.resource_path
	
	for child in get_children():
		child.queue_free()
	
	if level_path == "res://Level/ClassicLevel.tscn":
		var scene = level.instance()
		add_child(scene)
		scene.initializeClassicLevel(2, 0.7)
	elif level_path == "res://Level/LevelTileCount.tscn":
		var scene = level.instance()
		add_child(scene)
		scene.initializeTileCounter(2, 0.7, 30, 7)
	elif level_path == "res://Level/LevelTileDestroyer.tscn":
		var scene = level.instance()
		add_child(scene)
		scene.initializeTileDestroyer(2, 0.7, 7, 10)

#func _input(event):
#	if event.is_action_pressed("mouse_button_right"):
#		get_tree().change_scene(levels[1])
