extends Node2D

var tile_size = Globals.TILE_SIZE

export var level_size : Vector2 = Vector2(10,10)
export var number_of_animals : int = 4
export var MATCH_COUNT : int = 3

var all_tiles = []
var possible_tiles = []

func _ready():
	Globals.connect("HANDLE_MATCH_TILES", self, "HandleMatchTiles")
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
		yield(get_tree().create_timer(0.05), "timeout")
		for y in level_size.y:
			var end_position = Vector2(offset + (tile_size * x), offset + (tile_size * index))
			var tile = load(possible_tiles[randi() % number_of_animals]).instance()
			tile.position = end_position
			$Tiles.add_child(tile)
			index -= 1
			
		var detector = preload("res://Utils/ColumnDetector.tscn").instance()
		detector.position = Vector2(offset + (tile_size * x), tile_size * level_size.y)
		detector.cast_to = Vector2(0, (tile_size * -level_size.y))
		$Detectors.add_child(detector)
		
	get_tree().call_group("tiles", "EnableTextureButton")
			

func HandleMatchTiles(matches_count_number):
	if matches_count_number >= MATCH_COUNT:
		$AudioPlayer.play_sound()
		get_tree().call_group("matched", "Vanish")
		get_tree().call_group("detectors", "Detect")
