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
	Globals.emit_signal("HANDLE_TILE_CLICKED", self)
		
func VanishBlock():
	$AnimationPlayer.play("Vanish")
	
func DestroyBlock():
	var destroy_object = load("res://Plugins/destructible_object.tscn").instance()
	destroy_object.global_position = global_position
	destroy_object.get_node("sprite").texture = $TextureButton.texture_normal
	get_parent().add_child(destroy_object)
	
	queue_free()

func _on_Tween_tween_completed(_object, key):
	if key == ":position":
		Physics2DServer.area_set_param(get_viewport().find_world_2d().get_space(), 
		Physics2DServer.AREA_PARAM_GRAVITY, 98)
		
func SwipeTwoBlocks():
	SwipePosWithNeighbour(Globals.first_block.position)
	Globals.first_block.SwipePosWithNeighbour(position)
	Globals.first_block.HideNeighbours()
	Globals.first_block = null
