extends Node2D

var rotation_speed = 0

func _on_TextureButton_pressed():
	if Globals.state == Globals.SKILL_EFECTS.SMALL_BOMB:
		Globals.state = Globals.SKILL_EFECTS.NONE
		rotation_speed = 0
		rotation = 0
	else:
		Globals.state = Globals.SKILL_EFECTS.SMALL_BOMB
		rotation_speed = 5

func _physics_process(delta):
	rotate(rotation_speed * delta)
