extends AudioStreamPlayer

var music_tracks = []

func _ready():
	randomize()
	music_tracks = FileGrabber.get_file("res://Assets/Music/Tracks/")
	
func pick_song():
	stream = load(music_tracks[randi() % music_tracks.size() - 1])
	play()
