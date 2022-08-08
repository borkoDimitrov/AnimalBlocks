extends Node

signal GAME_OVER

var max_tiles : int
var current_tiles : int

func RemoveTiles(tiles):
	current_tiles -= tiles
	if current_tiles == 0:
		emit_signal("GAME_OVER")
