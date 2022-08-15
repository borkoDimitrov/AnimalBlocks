extends Node

var levelDificulty = 0
var levelTypeIndex = 0

var tileDestroyerEasy = {
	0 : [2, 0.3, 50, 5],
	1 : [3, 0.3, 5, 9]
}
var tileDestroyerHard = {
	0 : [4, 0.3, 50, 5],
	1 : [5, 0.3, 5, 9]
}
var tileDestroyerDiff = [tileDestroyerEasy, tileDestroyerHard]

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
	levelDificulty = levelTypeIndex / levels.size()
	var level = levels[2]
#	var level = levels[levelTypeIndex % levels.size()]
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
		scene.initializeTileCounter(2, 0.0, 30, 3)
		# EASY
		# 2, 0.3, 50, 5
		# 3, 0.3, 40, 5
		# 4, 0.3, 30, 5
		# 5, 0.3, 20, 5
		# 6, 0.3, 15, 5
		# 7, 0.3, 10, 5
		
		# NORMAL
		# 2, 0.3, 50, 7
		# 3, 0.3, 40, 7
		# 4, 0.3, 30, 7
		# 5, 0.3, 20, 7
		# 6, 0.3, 15, 7
		# 7, 0.3, 10, 7
		
		# HARD
		# 2, 0.1, 50, 5
		# 3, 0.1, 50, 5
		# 4, 0.1, 40, 5
		# 5, 0.1, 30, 5
		# 6, 0.1, 25, 5
		# 7, 0.1, 20, 5
		
		# EXPERT
		# 2, 0.0, 60, 5
		# 3, 0.0, 50, 5
		# 4, 0.0, 50, 3
		# 5, 0.0, 40, 4
		# 6, 0.0, 35, 3
		# 7, 0.0, 30, 3
	elif level_path == "res://Level/LevelTileDestroyer.tscn":
		var scene = level.instance()
		add_child(scene)
		var levelDif = tileDestroyerDiff[0][1]
		scene.initializeTileDestroyer(levelDif[0], levelDif[1], levelDif[2], levelDif[3])
		# EASY
		# 2, 0.3, 3, 10
		# 3, 0.3, 5, 9
		# 4, 0.3, 5, 10
		# 5, 0.3, 7, 7
		# 6, 0.3, 5, 7
		# 7, 0.3, 9, 6 maybe?
		
		# NORMAL
		# 2, 0.2, 6, 10
		# 3, 0.2, 9, 9
		# 4, 0.2, 9, 7
		# 5, 0.2, 9, 6
		# 6, 0.2, 9, 6
		# 7, 0.2, 8, 6
		
		# HARD
		# 2, 0.1, 6, 10
		# 3, 0.1, 8, 8
		# 4, 0.1, 8, 7
		# 5, 0.1, 7, 7
		# 6, 0.1, 7, 6
		# 7, 0.1, 10, 5
		
		# EXPERT
		# 2, 0.0, 6, 10
		# 3, 0.0, 7, 9
		# 4, 0.0, 7, 7
		# 5, 0.0, 9, 6
		# 6, 0.0, 11, 5
		# 7, 0.0, 13, 4
		
		
		
		
		
		
		
