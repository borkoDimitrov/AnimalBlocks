extends "res://Level/Level.gd"

export var TARGET_TILE_COUNT : int = 30
export var REFILMENT_MATCH_COUNT : int = 7
var tiles_left_count = TARGET_TILE_COUNT
var current_match_count = REFILMENT_MATCH_COUNT

var main_tile_id : String

func _ready():
	var firstTile = $Tiles.get_child(0)
	main_tile_id = firstTile.tile_info
	
	$"%TargetTileCount".text = "TILES LEFT: " + str(tiles_left_count)
	$"%RefilmentLabel".text = "MATCHES LEFT TO REFIL: " + str(current_match_count)
	
	$"%Sprite".texture = firstTile.get_node("TextureButton").texture_normal
	$"%Sprite".scale = Vector2(0.5, 0.5)
	
func OnMatch(tile, count):
	if main_tile_id == tile.tile_info:
		current_score += pow(count, 2)
		$"%Label".text = "SCORE: " + str(current_score)
		
	CountTiles(tile, count)
	.OnMatch(tile, count)
	
	ReduceRefilmentCount()
	if current_match_count == 0:
		current_match_count = REFILMENT_MATCH_COUNT
		$"%RefilmentLabel".text = "MATCHES LEFT TO REFIL: " + str(current_match_count)
		yield(get_tree().create_timer(0.2), "timeout")
		for detector in $Detectors.get_children():
			var currentTiles = detector.GetCurrentTilesCount()
			var tilesToSpawn = level_size.y - currentTiles
			if tilesToSpawn == 0 or currentTiles > 7:
				continue
			tilesToSpawn = min(3, tilesToSpawn)
			yield(get_tree().create_timer(0.1), "timeout")
			SpawnTiles(tilesToSpawn, detector.position)
		get_tree().call_group("tiles", "EnableBlockButton")

func SpawnTiles(count, position):
	for index in range(count):
		var figureId = possible_tiles[randi() % number_of_animals]
		var tile = load(figureId).instance()
		tile.tile_info = figureId
		var end_position = Vector2(position.x, -250 -(index * 140))
		tile.position = end_position
		$Tiles.add_child(tile)
	
	
func DestroyTile(tile):
	.DestroyTile(tile)
	ReduceTileCount(1)
	
func ReduceTileCount(count):
	tiles_left_count = max(0, tiles_left_count - count)
	$"%TargetTileCount".text = "TILES LEFT: " + str(tiles_left_count)
	
func ReduceRefilmentCount():
	current_match_count -= 1
	$"%RefilmentLabel".text = "MATCHES LEFT TO REFIL: " + str(current_match_count)

	
func CountTiles(tileType, tileCount):
	if main_tile_id == tileType.tile_info:
		ReduceTileCount(tileCount)
		if tiles_left_count <= 0:
			.LevelWon()

func _input(event):
	if event.is_action_pressed("mouse_button_right"):
		var test = load("res://TileDestroyer.tscn").instance()
		add_child(test)
		test.global_position = get_global_mouse_position()
	

