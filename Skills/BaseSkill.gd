extends Node2D

signal HANDLE_SKILL_ACTIVATION(current_skill)

export (int) var skill_uses_left = 3
var is_active = false

func SetSkillCount(skill_count):
	skill_uses_left = skill_count
	$RichTextLabel.text = str(skill_count)

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
