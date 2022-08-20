extends Node2D

signal HANDLE_SKILL_ACTIVATION(current_skill)

var sounds = [
	preload("res://Assets/Music/OtherSounds/b1.wav"),
	preload("res://Assets/Music/OtherSounds/b2.wav"),
	preload("res://Assets/Music/OtherSounds/b3.wav"),
	preload("res://Assets/Music/OtherSounds/b4.wav"),
	preload("res://Assets/Music/OtherSounds/b5.wav"),
	preload("res://Assets/Music/OtherSounds/b6.wav"),
	preload("res://Assets/Music/OtherSounds/b7.wav"),
	preload("res://Assets/Music/OtherSounds/b8.wav")
]

export (int) var skill_uses_left = 3
var is_active = false

func SetSkillCount(skill_count):
	skill_uses_left = skill_count
	$RichTextLabel.text = str(skill_count)
	
func play_sound():
	var random_sound = sounds[randi() % sounds.size() - 1]
	$AudioStreamPlayer2D.stream = random_sound
	$AudioStreamPlayer2D.play()

func OnButtonPressed():
	if IsActive():
		DeactivateSkill()
	else:
		ActivateSkill()
		
func ActivateSkill():
	if not CanBeActivated():
		return
		
	emit_signal("HANDLE_SKILL_ACTIVATION", self)
	is_active = true
	$AnimationPlayer.play("Pulse")

func DeactivateSkill():
	is_active = false
	$AnimationPlayer.play("RESET")
	rotation = 0
	
func IsActive() -> bool:
	return is_active
	
func CanBeActivated():
	return skill_uses_left > 0
	
func UseSkill():
	skill_uses_left -= 1
	$RichTextLabel.text = str(skill_uses_left)
	
	if not CanBeActivated():
		$RichTextLabel.modulate = Color.red

func OnMatchMade():
	pass
	
func HandleTileClick(_tile) -> bool:
	return false
