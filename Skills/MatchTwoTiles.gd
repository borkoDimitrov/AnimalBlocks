extends "res://Skills/BaseSkill.gd"

func DeactivateSkill():
	if not IsActive():
		return
		
	Globals.emit_signal("HANDLE_SET_MATCH_COUNT", 3)
	.DeactivateSkill()

func ActivateSkill():
	.ActivateSkill()
	
	if IsActive():
		Globals.emit_signal("HANDLE_SET_MATCH_COUNT", 2)
		
func OnMatchMade():
	if IsActive():
		UseSkill()
		DeactivateSkill()
