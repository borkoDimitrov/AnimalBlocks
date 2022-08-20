extends AudioStreamPlayer2D

var match_sounds = [
	preload("res://Assets/Music/MatchSounds/a1.wav"),
	preload("res://Assets/Music/MatchSounds/a2.wav"),
	preload("res://Assets/Music/MatchSounds/a3.wav"),
	preload("res://Assets/Music/MatchSounds/a4.wav"),
	preload("res://Assets/Music/MatchSounds/a5.wav"),
	preload("res://Assets/Music/MatchSounds/a6.wav"),
	preload("res://Assets/Music/MatchSounds/a7.wav"),
	preload("res://Assets/Music/MatchSounds/a8.wav"),
	preload("res://Assets/Music/MatchSounds/c1.wav"),
	preload("res://Assets/Music/MatchSounds/c2.wav"),
	preload("res://Assets/Music/MatchSounds/c3.wav"),
	preload("res://Assets/Music/MatchSounds/c4.wav"),
	preload("res://Assets/Music/MatchSounds/c5.wav"),
	preload("res://Assets/Music/MatchSounds/c6.wav"),
	preload("res://Assets/Music/MatchSounds/c7.wav"),
	preload("res://Assets/Music/MatchSounds/c8.wav"),
]

func play_sound():
	var random_sound = match_sounds[randi() % match_sounds.size() - 1]
	stream = random_sound
	play()
