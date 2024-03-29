extends "res://Level/Level.gd"

# FOR WINNING LEVEL
export var TARGET_TILE_MATCH = 10
export var TARGET_TILE_MATCH_COUNT = 7
var current_tile_match = TARGET_TILE_MATCH_COUNT

# FOR SPAWNING TILE DESTROYER
export var SPAWN_TILE_DESTROYER : int = 3
var current_match_count = SPAWN_TILE_DESTROYER
	
func initializeTileDestroyer(_number_of_animals, _weight, _big_matches_count, _big_matches_size):
	.initialize(_number_of_animals, _weight)
	TARGET_TILE_MATCH = _big_matches_size
	TARGET_TILE_MATCH_COUNT = _big_matches_count
	current_tile_match = TARGET_TILE_MATCH_COUNT

	$"%Rules".text = "MATCH " + str(TARGET_TILE_MATCH) + " OR MORE"
	$"%BombLeft".text = str(SPAWN_TILE_DESTROYER)
	$"%MatchLeft".text = str(TARGET_TILE_MATCH_COUNT)

func OnMatch(tile, count):
	.OnMatch(tile, count)
	
	if count >= TARGET_TILE_MATCH:
		current_tile_match = max(0, current_tile_match - 1)
		if current_tile_match == 0:
			$"%MatchLeft".modulate = Color.green
		$"%MatchLeft".text = str(current_tile_match)
		current_score += pow(count, 2)
		$"%Label".text = "SCORE: " + str(current_score)
		
		if current_tile_match == 0:
			.LevelWon()
			return
		
	current_match_count -= 1
	$"%BombLeft".text = str(current_match_count)
	if current_match_count == 0:
		current_match_count = SPAWN_TILE_DESTROYER
		$"%BombLeft".text = str(current_match_count)	
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
	var positionY = range_lerp(childCount,0, 9, -350, -500)
		
	var tileDestroy = load("res://TileDestroyer.tscn").instance()
	$Tiles.add_child(tileDestroy)
	tileDestroy.gravity_scale = gravityScale
	tileDestroy.global_position = Vector2(detector.global_position.x, positionY) 
	
	yield(get_tree().create_timer(1),"timeout")
	SpawnTiles(level_size.y, detector.global_position)

