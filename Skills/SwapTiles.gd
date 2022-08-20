extends "res://Skills/BaseSkill.gd"

var first_tile = null

func DeactivateSkill():
	if not IsActive():
		return
		
	if first_tile != null:
		first_tile.HideNeighbours()
		first_tile = null
		
	.DeactivateSkill()

func SwipeWithTile(second_tile):
	second_tile.SwipePosWithNeighbour(first_tile.position)
	first_tile.SwipePosWithNeighbour(second_tile.position)
	first_tile.HideNeighbours()
	first_tile = null

func HandleTileClick(tile) -> bool:
	if first_tile != null and first_tile.IsNeighbour(tile):
		play_sound()
		SwipeWithTile(tile)
		UseSkill()
		DeactivateSkill()
	elif first_tile != null:
			first_tile.HideNeighbours()
			if first_tile != tile:
				first_tile = tile
				tile.ShowNeighbours()
			else:
				first_tile = null
				DeactivateSkill()
	else:
		first_tile = tile
		tile.ShowNeighbours()
		
	return true
