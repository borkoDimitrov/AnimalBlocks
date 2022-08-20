extends "res://Skills/BaseSkill.gd"

signal DESTROY_TILE(tile)

func HandleTileClick(tile) -> bool:
	emit_signal("DESTROY_TILE", tile)
	
	play_sound()
	
	UseSkill()
	DeactivateSkill()
	
	return true
