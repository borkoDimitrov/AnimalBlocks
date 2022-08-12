extends Node2D

var tile_size = Globals.TILE_SIZE
var current_score : int = 0

export var level_size : Vector2 = Vector2(10,10)
export var number_of_animals : int = 4
export var match_count : int = 3
export var weight : float = 0.5

var all_tiles = []
var possible_tiles = []

func _ready():
	Globals.connect("HANDLE_TILE_CLICKED", self, "HandleTileClicked")
	$"%SmallBomb".connect("DESTROY_TILE", self, "DestroyTile")
	$"%MatchTwoTiles".connect("HANDLE_SET_MATCH_COUNT", self, "HandleSetMatchCount")
	for skill in $"%Skills".get_children():
		skill.connect("HANDLE_SKILL_ACTIVATION", self, "HandleSkillActivation")
#	$MusicPlayer.pick_song()
	
	randomize()
	refresh_level()
	
func refresh_level():
	make_tile_types()
	create_grid()
	$Floor.position.y = (tile_size * level_size.y) + 70
	
func GetWeightedFigureId(matrix, x, y):
	var neighbours = Globals.GetNeighbours(matrix, x, y)
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
			
	var matrix = Globals.create_2d_vector(level_size)
	
	for x in level_size.x:
		var index = level_size.y - 1
		for y in level_size.y:
			var figureId = GetWeightedFigureId(matrix, x, y)
			var end_position = Vector2( (tile_size * x), -(tile_size * index) - 250)
			index -= 1
			
			var tile = load(figureId).instance()
			tile.tile_info = figureId
			tile.position = end_position
			$Tiles.add_child(tile)
			
			matrix[x][y] = tile
		yield(get_tree().create_timer(0.1), "timeout")
			
		var detector = preload("res://Utils/ColumnDetector.tscn").instance()
		detector.position = Vector2((tile_size * x), tile_size * level_size.y)
		detector.cast_to = Vector2(0, (tile_size * -level_size.y))
		$Detectors.add_child(detector)
		
	var tween := create_tween()
	tween.tween_property($CanvasLayer/TilesBackground, "modulate:a", 0.9, 1.5).from(0.0)
	
	get_tree().call_group("tiles", "EnableBlockButton")

	for x in level_size.x:
		yield(get_tree().create_timer(0.1), "timeout")
		var player = $AudioPlayer.duplicate()
		add_child(player)
		player.play_sound()
		player.connect("finished", player, "queue_free")

func SpawnTiles(count, position):
	for index in range(count):
		var figureId = possible_tiles[randi() % number_of_animals]
		var tile = load(figureId).instance()
		tile.tile_info = figureId
		var end_position = Vector2(position.x, -250 -(index * 140))
		tile.position = end_position
		$Tiles.add_child(tile)

func HandleTileClicked(tile):
	for skill in $"%Skills".get_children():
		if skill.IsActive() and skill.HandleTileClick(tile):
			return
	
	HandleMatchTiles(tile)
		
func HandleSkillActivation(current_skill):
	for skill in $"%Skills".get_children():
		if skill != current_skill:
			skill.DeactivateSkill()

func DestroyTile(tile):
	tile.DestroyBlock()
	
func HandleMatchTiles(tile):
	var group_count = tile.MarkMatchingGroup()
	
	if group_count >= match_count:
		CreateLabelForMatch(tile, group_count)
		OnMatch(tile, group_count)
	
	tile.UnmarkMatchingGroup()

func OnMatch(tile, count):
	$AudioPlayer.play_sound()
	get_tree().call_group("matched", "VanishBlock")
	
	for skill in $"%Skills".get_children():
		skill.OnMatchMade()
	
func HandleSetMatchCount(count):
	match_count = count

func CreateLabelForMatch(tile, count):
	var score = load("res://Utils/MatchLabel.tscn").instance()
	score.rect_global_position = tile.global_position
	score.text = str(count)
	score.modulate = tile.GetPixelColor()
	add_child(score)
	
	var pos = score.rect_position
	var tweenDelay = 0.5
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(score, "rect_position", Vector2(pos.x - 20, pos.y - 150),tweenDelay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).from(Vector2(pos.x - 10, pos.y - 70))
	tween.tween_property(score, "rect_scale", Vector2(0.5,0.5), tweenDelay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(score, "modulate:a", 0.4, tweenDelay)
	tween.tween_callback(score, "queue_free").set_delay(tweenDelay)
	
func CountSkillsScore():
	current_score += $"%SwapTiles".skill_uses_left * 100
	current_score += $"%MatchTwoTiles".skill_uses_left * 75
	current_score += $"%SmallBomb".skill_uses_left * 50

func LevelWon():
	print("LEVEL WON")
	yield(get_tree().create_timer(1), "timeout")
	CountSkillsScore()
	$"%Label".text = "SCORE: " + str(current_score)
	
	yield(get_tree().create_timer(5), "timeout")
	get_tree().reload_current_scene()