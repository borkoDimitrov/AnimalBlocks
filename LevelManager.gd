extends Node

var completedLevelsCount = 0

onready var levels = [
	preload("res://Level/ClassicLevel.tscn"),
	preload("res://Level/LevelTileCount.tscn"),
	preload("res://Level/LevelTileDestroyer.tscn")]

func _ready():
	Globals.connect("HANDLE_LEVEL_WON", self, "HandleLevelWon")
	StartNextLevel()
	
func HandleLevelWon():
	completedLevelsCount += 1
	StartNextLevel()
	
func StartNextLevel():
	var levelDificulty = completedLevelsCount / levels.size()
	var level = levels[completedLevelsCount % levels.size()]
	var level_path = level.resource_path
	
	for child in get_children():
		if child.name != "LevelDificulties":
			child.queue_free()
	
	if level_path == "res://Level/ClassicLevel.tscn":
		var scene = level.instance()
		add_child(scene)
		var levelDif = $LevelDificulties.tileClassicLevels[levelDificulty]
		scene.initializeClassicLevel(levelDif[0], levelDif[1])
	elif level_path == "res://Level/LevelTileCount.tscn":
		var scene = level.instance()
		add_child(scene)
		var levelDif = $LevelDificulties.tileCounterLevels[levelDificulty]
		scene.initializeTileCounter(levelDif[0], levelDif[1], levelDif[2], levelDif[3])
		
	elif level_path == "res://Level/LevelTileDestroyer.tscn":
		var scene = level.instance()
		add_child(scene)
		var levelDif = $LevelDificulties.tileDestroyerLevels[levelDificulty]
		scene.initializeTileDestroyer(levelDif[0], levelDif[1], levelDif[2], levelDif[3])
