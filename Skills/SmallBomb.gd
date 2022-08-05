extends "res://Skills/BaseSkill.gd"


func HandleTileClick(tile) -> bool:
	tile.DestroyBlock()
	UseSkill()
	DeactivateSkill()
	
	return true
