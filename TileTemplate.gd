extends RigidBody2D

var tile_id = ""
onready var raycasts = [$Left, $Right, $Up, $Down]

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

func EnableTextureButton():
	$TextureButton.disabled = false

func _on_TextureButton_pressed():
	var count = [0]
	AddToGroup(count)
	
	Globals.emit_signal("HANDLE_MATCH_TILES", count.front())
	get_tree().call_group("matched", "RemoveFromGroup")
	
func Vanish():
	$AnimationPlayer.play("Vanish")

func slide_left(detector_position):
	if position.x > detector_position:
		$Tween.interpolate_property(self, "position:x", position.x,
			position.x - Globals.TILE_SIZE, 0.15, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		$Tween.start();
