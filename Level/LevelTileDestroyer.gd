extends "res://Level/Level.gd"

# FOR WINNING LEVEL
export var TARGET_TILE_MATCH = 7
export var TARGET_TILE_MATCH_COUNT = 5

# FOR SPAWNING TILE DESTROYER
export var SPAWN_TILE_DESTROYER : int = 3
var current_match_count = SPAWN_TILE_DESTROYER

func OnMatch(tile, count):
	.OnMatch(tile, count)
	
	current_match_count -= 1
	if current_match_count == 0:
		current_match_count = SPAWN_TILE_DESTROYER
		SpawnTileDestroyer()
		
func SpawnTileDestroyer():
	var randIdx = randi() % $Detectors.get_child_count()
	var detector = $Detectors.get_child(randIdx)
	while detector.GetCurrentTilesCount() <= 0:
		randIdx = randi() % $Detectors.get_child_count()
		detector = $Detectors.get_child(randIdx)
	
	yield(get_tree().create_timer(0.2),"timeout")
	var childCount = detector.GetCurrentTilesCount()
	var gravityScale = range_lerp(childCount,0, 9, 10, 50)
	var positionY = range_lerp(childCount,0, 9, -200, -400)
		
	var tileDestroy = load("res://TileDestroyer.tscn").instance()
	$Tiles.add_child(tileDestroy)
	tileDestroy.gravity_scale = gravityScale
	tileDestroy.global_position = Vector2(detector.global_position.x, positionY) 
	
	yield(get_tree().create_timer(1),"timeout")
	SpawnTiles(level_size.y, detector.global_position)

