extends AudioStreamPlayer2D

var match_sounds = []

func _ready():
	randomize()
	match_sounds = FileGrabber.get_file("res://Assets/Music/MatchSounds/")

func play_sound():
	var random_sound = match_sounds[randi() % match_sounds.size() - 1]
	stream = load(random_sound)
	play()
