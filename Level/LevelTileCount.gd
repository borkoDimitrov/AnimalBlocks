extends "res://Level/Level.gd"

export var target_tile_count : int = 20
var current_tile_count : int = 0

var main_tile_id : String

func _ready():
	var index = randi() % possible_tiles.size()
	main_tile_id = possible_tiles[index]
	
#	var tileScene = load(main_tile_id).instance()
#	tileScene.get_node("TextureButton").disabled = true
#	tileScene.gravity_scale = 0
#	$CanvasLayer.add_child(tileScene)
#	tileScene.global_position = $CanvasLayer/Position2D.global_position
	
func OnMatch(tile, count):
	CountTiles(tile, count)
	.OnMatch(tile, count)
	
func CountTiles(tileType, tileCount):
	if main_tile_id == tileType.tile_info:
		current_tile_count -= tileCount
		if current_tile_count <= target_tile_count:
			.LevelWon()


