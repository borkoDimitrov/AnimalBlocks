extends "res://Skills/BaseSkill.gd"

signal HANDLE_SET_MATCH_COUNT(match_count)

func DeactivateSkill():
	if not IsActive():
		return
		
	emit_signal("HANDLE_SET_MATCH_COUNT", 3)
	.DeactivateSkill()

func ActivateSkill():
	.ActivateSkill()
	
	if IsActive():
		emit_signal("HANDLE_SET_MATCH_COUNT", 2)
		
func OnMatchMade():
	if IsActive():
		UseSkill()
		DeactivateSkill()
