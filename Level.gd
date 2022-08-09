extends Node2D

var MATCH_LABEL = preload("res://Utils/MatchLabel.tscn")

var tile_size = Globals.TILE_SIZE
var current_score : int = 0

export var level_size : Vector2 = Vector2(10,10)
export var number_of_animals : int = 4
export var match_count : int = 3
export var weight : float = 0.5

var all_tiles = []
var possible_tiles = []

func _ready():
	$LevelManager.connect("GAME_OVER", self, "GameOver")
	Globals.connect("HANDLE_TILE_CLICKED", self, "HandleTileClicked")
	$CanvasLayer/Skills/SmallBomb.connect("DESTROY_TILE", self, "DestroyTile")
	$CanvasLayer/Skills/MatchTwoTiles.connect("HANDLE_SET_MATCH_COUNT", self, "HandleSetMatchCount")
	for skill in $CanvasLayer/Skills.get_children():
		skill.connect("HANDLE_SKILL_ACTIVATION", self, "HandleSkillActivation")
#	$MusicPlayer.pick_song()
	
	randomize()
	refresh_level()
	
func refresh_level():
	make_tile_types()
	create_grid()
	$Floor.position.y = tile_size * level_size.y
	$LevelManager.max_tiles = level_size.x * level_size.y
	$LevelManager.current_tiles = level_size.x * level_size.y
	
func create_2d_vector():
	var array = []
	for i in level_size.x:
		array.append([])
		for j in level_size.y:
			array[i].append(null)
	return array
	
func GetNeighbours(matrix, i, j):
	var result = []
	if i > 0 and matrix[i-1][j] != null:
		result.append(matrix[i-1][j])
	if j > 0 and matrix[i][j-1] != null:
		result.append(matrix[i][j-1])
	if i + 1 < matrix.size() and matrix[i+1][j] != null:
		result.append(matrix[i+1][j])
	if j + 1 < matrix[i].size() and matrix[i][j+1] != null:
		result.append(matrix[i][j+1])
	return result
	
func GetWeightedFigureId(matrix, x, y, weight):
	var neighbours = GetNeighbours(matrix, x, y)
	var figureId = possible_tiles[randi() % number_of_animals]
	if neighbours.size() <= 0:
		return figureId
		
	# Find first neighbour weight which is bigger than the drawn random number
	var weightPerNeighbour = weight / neighbours.size()
	var curr = weightPerNeighbour
	var number = randf()
	var id = 0
	while number >= curr and id < neighbours.size():
		curr += weightPerNeighbour
		id += 1
		
	# rnd is bigger than the neighbours weights
	if id < neighbours.size():
		figureId = neighbours[id].tile_info
			
	return figureId
	
func make_tile_types():
	all_tiles = FileGrabber.get_file("res://Tiles/")
	all_tiles.shuffle()
	for i in number_of_animals:
		possible_tiles.append(all_tiles[i])
	
func create_grid():
	var offset = tile_size / 2
	$Camera2D.position = Vector2((level_size.x * tile_size + offset) / 2,
		 (level_size.y * tile_size + offset) / 2)
			
	var matrix = create_2d_vector()
	
	for x in level_size.x:
		var index = level_size.y - 1
		yield(get_tree().create_timer(0.1), "timeout")
		for y in level_size.y:
			var figureId = GetWeightedFigureId(matrix, x, y, weight)
			var end_position = Vector2(offset + (tile_size * x), -(tile_size * index) - 250)
			index -= 1
			
			var tile = load(figureId).instance()
			tile.tile_info = figureId
			tile.position = end_position
			$Tiles.add_child(tile)
			
			matrix[x][y] = tile
			
		var detector = preload("res://Utils/ColumnDetector.tscn").instance()
		detector.position = Vector2(offset + (tile_size * x), tile_size * level_size.y)
		detector.cast_to = Vector2(0, (tile_size * -level_size.y))
		$Detectors.add_child(detector)
		
	get_tree().call_group("tiles", "EnableBlockButton")

	for x in level_size.x:
		yield(get_tree().create_timer(0.1), "timeout")
		var player = $AudioPlayer.duplicate()
		add_child(player)
		player.play_sound()
		player.connect("finished", player, "queue_free")

func HandleTileClicked(tile):
	for skill in $CanvasLayer/Skills.get_children():
		if skill.IsActive() and skill.HandleTileClick(tile):
			return
	
	HandleMatchTiles(tile)
		
func HandleSkillActivation(current_skill):
	for skill in $CanvasLayer/Skills.get_children():
		if skill != current_skill:
			skill.DeactivateSkill()

func DestroyTile(tile):
	$LevelManager.CountTiles(1)
	tile.DestroyBlock()
	
func HandleMatchTiles(tile):
	var group_count = tile.MarkMatchingGroup()
	
	if group_count >= match_count:
		CreateLabelForMatch(tile, group_count)
		OnMatch(group_count)
		
#		yield(get_tree().create_timer(0.2), "timeout")
#		var currentTiles = $Detectors.get_child(0).GetCurrentTilesCount()
	
	tile.UnmarkMatchingGroup()

func OnMatch(count):
	$LevelManager.CountTiles(count)
	current_score += pow(count, 2)
	$CanvasLayer/Label.text = "SCORE: " + str(current_score)
	
	$AudioPlayer.play_sound()
	get_tree().call_group("matched", "VanishBlock")
	get_tree().call_group("detectors", "DetectBlocks")
	
	for skill in $CanvasLayer/Skills.get_children():
		skill.OnMatchMade()
	
func HandleSetMatchCount(count):
	match_count = count

func CreateLabelForMatch(tile, count):
	var score = MATCH_LABEL.instance()
	score.rect_global_position = tile.global_position
	score.text = str(count)
	add_child(score)
	
	var image = tile.button.texture_normal.get_data()
	image.lock()
	score.modulate = image.get_pixel(10, 10)
	image.unlock()
	
	var pos = score.rect_position
	var offset = randi() % 100 + 60
	print(offset)
	$Tween.interpolate_property(score, "rect_position",
	 Vector2(pos.x, pos.y - 40), Vector2(pos.x - 10, pos.y - offset),0.8,
	Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
func CountSkillsLeft():
	current_score += $CanvasLayer/Skills/SwapTiles.skill_uses_left * 100
	current_score += $CanvasLayer/Skills/MatchTwoTiles.skill_uses_left * 75 
	current_score += $CanvasLayer/Skills/SmallBomb.skill_uses_left * 50

func GameOver():
	yield(get_tree().create_timer(1), "timeout")
	CountSkillsLeft()
	$CanvasLayer/Label.text = "SCORE: " + str(current_score)
	
	yield(get_tree().create_timer(5), "timeout")
	get_tree().reload_current_scene()

func _on_Tween_tween_completed(object, _key):
	object.queue_free()
