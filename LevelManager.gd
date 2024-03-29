extends Node

var completedLevelsCount = 0
var bomb_count : int
var swap_count : int
var match_count : int

onready var levels = []

func _ready():
	Globals.connect("HANDLE_LEVEL_WON", self, "HandleLevelWon")
	Globals.connect("RELOAD_CURRENT_LEVEL", self, "ReloadCurrentLevel")
	
	randomize()
	HandleStartGame()
	StartLevel()
	
func HandleStartGame():
	if Globals.type_of_game == "normal_game":
		levels.append(preload("res://Level/ClassicLevel.tscn"))
		levels.append(preload("res://Level/LevelTileCount.tscn"))
		levels.append(preload("res://Level/LevelTileDestroyer.tscn"))
	if Globals.type_of_game == "classic_game":
		levels.append(preload("res://Level/ClassicLevel.tscn"))
	if Globals.type_of_game == "count_game":
		levels.append(preload("res://Level/LevelTileCount.tscn"))
	if Globals.type_of_game == "match_game":
		levels.append(preload("res://Level/LevelTileDestroyer.tscn"))
	
func HandleLevelWon():
	if Globals.random_game:
		completedLevelsCount = randi() % 72
	else:
		completedLevelsCount += 1
		
	StartLevel()
	
func HandleSkillCount(levelDificulty):
	if levelDificulty < 6:
			bomb_count = 3
			swap_count = 3
			match_count = 3
	elif levelDificulty < 12:
			bomb_count = 3
			swap_count = 2
			match_count = 2
	elif levelDificulty < 18:
			bomb_count = 2
			swap_count = 1
			match_count = 2
	else:
			bomb_count = 1
			swap_count = 1
			match_count = 1
			
func StartLevel():
	var levelDificulty = completedLevelsCount / levels.size()
	var levelType = completedLevelsCount % levels.size()
	var level = levels[levelType]
	var level_path = level.resource_path
	
	for child in get_children():
		if child.name != "LevelDificulties":
			child.queue_free()
	
	HandleSkillCount(levelDificulty)
	
	if level_path == "res://Level/ClassicLevel.tscn":
		var scene = level.instance()
		add_child(scene)
		var levelDif = $LevelDificulties.tileClassicLevels[levelDificulty]
		scene.initializeClassicLevel(levelDif[0], levelDif[1])
		scene.SetSkillsCount(5, 5, 5)
		
	elif level_path == "res://Level/LevelTileCount.tscn":
		var scene = level.instance()
		add_child(scene)
		var levelDif = $LevelDificulties.tileCounterLevels[levelDificulty]
		scene.initializeTileCounter(levelDif[0], levelDif[1], levelDif[2], levelDif[3])
		scene.SetSkillsCount(match_count, swap_count, bomb_count)
		
	elif level_path == "res://Level/LevelTileDestroyer.tscn":
		var scene = level.instance()
		add_child(scene)
		var levelDif = $LevelDificulties.tileDestroyerLevels[levelDificulty]
		scene.initializeTileDestroyer(levelDif[0], levelDif[1], levelDif[2], levelDif[3])
		scene.SetSkillsCount(match_count, swap_count, bomb_count)
		
func ReloadCurrentLevel():
	StartLevel()
