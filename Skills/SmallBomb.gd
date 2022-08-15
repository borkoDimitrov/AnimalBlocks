extends "res://Skills/BaseSkill.gd"

signal DESTROY_TILE(tile)

func HandleTileClick(tile) -> bool:
	emit_signal("DESTROY_TILE", tile)
	
	$AudioStreamPlayer2D.play()
	
	UseSkill()
	DeactivateSkill()
	
	return true
