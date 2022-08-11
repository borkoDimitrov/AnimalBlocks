extends "res://Skills/BaseSkill.gd"

signal DESTROY_TILE(tile)

func HandleTileClick(tile) -> bool:
	emit_signal("DESTROY_TILE", tile)
	
	UseSkill()
	DeactivateSkill()
	
	return true
