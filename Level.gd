extends Node2D

var tile_size = Globals.TILE_SIZE

export var level_size : Vector2 = Vector2(10,10)
export var number_of_animals : int = 4
export var match_count : int = 3

var all_tiles = []
var possible_tiles = []

func _ready():
	Globals.connect("HANDLE_TILE_CLICKED", self, "HandleTileClicked")
	Globals.connect("HANDLE_SKILL_ACTIVATION", self, "HandleSkillActivation")
	Globals.connect("HANDLE_SET_MATCH_COUNT", self, "HandleSetMatchCount")
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
	for skill in $CanvasLayer/Skills.get_children():
		if skill.IsActive() and skill.HandleTileClick(tile):
			return
	
	HandleMatchTiles(tile)
		
func HandleSkillActivation(current_skill):
	for skill in $CanvasLayer/Skills.get_children():
		if skill != current_skill:
			skill.DeactivateSkill()

func OnMatch():
	$AudioPlayer.play_sound()
	get_tree().call_group("matched", "VanishBlock")
	get_tree().call_group("detectors", "DetectBlocks")
	
	for skill in $CanvasLayer/Skills.get_children():
		skill.OnMatchMade()
	
func HandleMatchTiles(tile):
	var group_count = tile.MarkMatchingGroup()
	
	if group_count >= match_count:
		OnMatch()
		
#		yield(get_tree().create_timer(0.2), "timeout")
#		var currentTiles = $Detectors.get_child(0).GetCurrentTilesCount()
	
	tile.UnmarkMatchingGroup()

func HandleSetMatchCount(count):
	match_count = count
	
