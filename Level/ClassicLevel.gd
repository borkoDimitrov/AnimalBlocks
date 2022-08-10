extends "res://Level/Level.gd"

var max_tiles : int
var current_tiles : int

func _ready():
	max_tiles = level_size.x * level_size.y
	current_tiles = level_size.x * level_size.y

func DestroyTile(tile):
	CountTiles(1)
	.DestroyTile(tile)
	
func OnMatch(tile, count):
	CountTiles(count)
	.OnMatch(tile, count)

func CountTiles(tileCount):
	current_tiles -= tileCount
	if current_tiles == 0:
		LevelWon()
	
