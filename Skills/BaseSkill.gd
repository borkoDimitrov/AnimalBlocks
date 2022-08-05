extends Node2D

export (int) var skill_uses_left = 3
var is_active = false
var rotation_speed = 0

func _ready():
	$RichTextLabel.text = str(skill_uses_left)

func OnButtonPressed():
	if IsActive():
		DeactivateSkill()
	else:
		ActivateSkill()
		
func ActivateSkill():
	if not CanBeActivated():
		return
		
	Globals.emit_signal("HANDLE_SKILL_ACTIVATION", self)
	is_active = true
	rotation_speed = 5
	
func DeactivateSkill():
	Globals.emit_signal("HANDLE_SKILL_DEACTIVATION", self)
	is_active = false
	rotation_speed = 0
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
		
func _physics_process(delta):
	rotate(rotation_speed * delta)
