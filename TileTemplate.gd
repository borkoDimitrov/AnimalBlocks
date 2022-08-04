extends RigidBody2D

var tile_id = ""
onready var raycasts = [$Left, $Right, $Up, $Down]
onready var anim_player = $AnimationPlayer

func _ready():
	tile_id = $TextureButton.texture_normal

func AddToGroup(count : Array): # we pass array because it can be passed by reference
	add_to_group("matched")
	count[0] += 1
	
	for ray in raycasts:
		var tileCollider = ray.get_collider()
		if tileCollider != null and tileCollider.tile_id == tile_id and not tileCollider.is_in_group("matched"):
			tileCollider.AddToGroup(count)

func RemoveFromGroup():
	remove_from_group("matched")

func EnableBlockButton():
	$TextureButton.disabled = false

func HandleMatches():
	var count = [0]
	AddToGroup(count)
	
	Globals.emit_signal("HANDLE_MATCH_TILES", count.front())
	get_tree().call_group("matched", "RemoveFromGroup")

func ShowNeighbours():
	for ray in raycasts:
		var tileCollider = ray.get_collider()
		if tileCollider != null:
			tileCollider.anim_player.play("Blink")

func IsNeighbour(cell) -> bool:
	for ray in raycasts:
		var tileCollider = ray.get_collider()
		if tileCollider == cell:
			return true
	return false

func HideNeighbours():
	for ray in Globals.first_block.raycasts:
		var tileCollider = ray.get_collider()
		if tileCollider != null:
			tileCollider.anim_player.play("RESET")
			
func SwipePosWithNeighbour(other_pos):
	Physics2DServer.area_set_param(get_viewport().find_world_2d().get_space(),
	 Physics2DServer.AREA_PARAM_GRAVITY, 20)
	
	$Tween.interpolate_property(self, "position", position,
			other_pos, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start();

func SlideLeft(detector_position):
	if position.x > detector_position:
		$Tween.interpolate_property(self, "position:x", position.x,
			position.x - Globals.TILE_SIZE, 0.15, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		$Tween.start();
		
func _on_TextureButton_pressed():
	match Globals.state:
		Globals.SKILL_EFECTS.SWITCH:
			if Globals.first_block != null and Globals.first_block.IsNeighbour(self):
				SwipeTwoBlocks()
			elif Globals.first_block != null:
				ChooseNewBlock()
			else:
				Globals.first_block = self
				ShowNeighbours()
				
		Globals.SKILL_EFECTS.SMALL_BOMB:
			DestroyBlock()
		Globals.SKILL_EFECTS.NONE:
			HandleMatches()
		
func DestroyBlock():
	$AnimationPlayer.play("Vanish")

func _on_Tween_tween_completed(_object, key):
	if key == ":position":
		Physics2DServer.area_set_param(get_viewport().find_world_2d().get_space(), 
		Physics2DServer.AREA_PARAM_GRAVITY, 98)
		
#SKILLS
func SwipeTwoBlocks():
	SwipePosWithNeighbour(Globals.first_block.position)
	Globals.first_block.SwipePosWithNeighbour(position)
	Globals.first_block.HideNeighbours()
	Globals.first_block = null
	
func ChooseNewBlock():
	Globals.first_block.HideNeighbours()
	if Globals.first_block != self:
		Globals.first_block = self
		ShowNeighbours()
	else:
		Globals.first_block = null
