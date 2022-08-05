extends Node2D

var tile_size = Globals.TILE_SIZE

onready var SmallBomb = $CanvasLayer/Skills/SmallBomb
onready var SwapTiles = $CanvasLayer/Skills/SwapTiles
onready var MatchTwoTiles = $CanvasLayer/Skills/MatchTwoTiles

export var level_size : Vector2 = Vector2(10,10)
export var number_of_animals : int = 4
export var match_count : int = 3

var all_tiles = []
var possible_tiles = []

func _ready():
	Globals.connect("HANDLE_MATCH_TILES", self, "HandleMatchTiles")
	Globals.connect("HANDLE_TILE_CLICKED", self, "HandleTileClicked")
	Globals.connect("HANDLE_SKILL_ACTIVATION", self, "HandleSkillActivation")
	Globals.connect("HANDLE_SKILL_DEACTIVATION", self, "HandleSkillDeactivation")
#	$MusicPlayer.pick_song()
	
	randomize()
	make_tile_types()
	create_grid()
	$Floor.position.y = tile_size * level_size.y
	
func make_tile_types():
	all_tiles = FileGrabber.get_file("res://Tiles/")
	all_tiles.shuffle()
	for i in number_of_animals:
		possible_tiles.append(all_tiles[i])
	
func create_grid():
	var offset = tile_size / 2
	$Camera2D.position = Vector2((level_size.x * tile_size + offset) / 2,
		 (level_size.y * tile_size + offset) / 2)
			
	for x in level_size.x:
		var index = level_size.y - 1
		yield(get_tree().create_timer(0.1), "timeout")
		for y in level_size.y:
			var end_position = Vector2(offset + (tile_size * x), -(tile_size * index) - 250)
			var tile = load(possible_tiles[randi() % number_of_animals]).instance()
			tile.position = end_position
			$Tiles.add_child(tile)
			index -= 1
			
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
	if SmallBomb.IsActive():
		HandleSmallBomb(tile)
		
	elif SwapTiles.IsActive():
		HandleTileSwap(tile)
		
	elif MatchTwoTiles.IsActive():
		HandleMatchTwoTiles(tile)
		
	else:
		tile.HandleMatches()
			
func HandleMatchTiles(matches_count_number):
	if matches_count_number >= match_count:
		$AudioPlayer.play_sound()
		get_tree().call_group("matched", "VanishBlock")
		get_tree().call_group("detectors", "DetectBlocks")
		
#		yield(get_tree().create_timer(0.2), "timeout")
#		var currentTiles = $Detectors.get_child(0).GetCurrentTilesCount()
		
func HandleSkillActivation(current_skill):
	for skill in $CanvasLayer/Skills.get_children():
		if skill != current_skill:
			skill.DeactivateSkill()
			
func HandleSkillDeactivation(current_skill):
	if current_skill == MatchTwoTiles:
		match_count = 3
	elif current_skill == SwapTiles:
		if Globals.first_block != null:
			Globals.first_block.HideNeighbours()
			Globals.first_block = null
			
func HandleMatchTwoTiles(tile):
	match_count = 2
	tile.HandleMatches()
	MatchTwoTiles.UseSkill()
	MatchTwoTiles.DeactivateSkill()
			
func HandleSmallBomb(tile):
	tile.DestroyBlock()
	SmallBomb.UseSkill()
	SmallBomb.DeactivateSkill()
			
func HandleTileSwap(tile):
	if Globals.first_block != null and Globals.first_block.IsNeighbour(tile):
		tile.SwipeTwoBlocks()
		SwapTiles.UseSkill()
		SwapTiles.DeactivateSkill()
	elif Globals.first_block != null:
			Globals.first_block.HideNeighbours()
			if Globals.first_block != tile:
				Globals.first_block = tile
				tile.ShowNeighbours()
			else:
				Globals.first_block = null
				SwapTiles.DeactivateSkill()
	else:
		Globals.first_block = tile
		tile.ShowNeighbours()
	
