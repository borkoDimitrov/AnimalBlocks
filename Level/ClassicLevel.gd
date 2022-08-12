extends "res://Level/Level.gd"

var max_tiles : int
var current_tiles : int

func initializeClassicLevel(_number_of_animals, _weight):
	.initialize(_number_of_animals, _weight)
	max_tiles = level_size.x * level_size.y
	current_tiles = level_size.x * level_size.y

func DestroyTile(tile):
	CountTiles(1)
	.DestroyTile(tile)
	
func OnMatch(tile, count):
	current_score += pow(count, 2)
	$"%Label".text = "SCORE: " + str(current_score)
	
	get_tree().call_group("detectors", "DetectBlocks")
	
	CountTiles(count)
	.OnMatch(tile, count)

func CountTiles(tileCount):
	current_tiles -= tileCount
	if current_tiles == 0:
		.LevelWon()
	
