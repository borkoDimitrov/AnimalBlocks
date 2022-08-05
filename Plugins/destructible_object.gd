extends RigidBody2D

export (int, 2, 10, 2) var blocks_per_side = 6
export (float) var blocks_impulse = 500
export (float) var blocks_gravity_scale = 12
export (float) var debris_max_time = 1
export (bool) var explosion_delay = false
export (bool) var randomize_seed = false

var object = {}

var explosion_delay_timer = 0
var explosion_delay_timer_limit = 0

func _ready():
	object = {
		blocks = [],
		blocks_container = Node2D.new(),
		blocks_gravity_scale = blocks_gravity_scale,
		blocks_impulse = blocks_impulse,
		blocks_per_side = blocks_per_side,
		can_detonate = true,
		debris_max_time = debris_max_time,
		debris_timer = Timer.new(),
		detonate = false,
		frame = 0,
		has_detonated = false,
		has_particles = false,
		height = 0,
		hframes = 1,
		offset = Vector2(),
		parent = get_parent(),
		particles = null,
		sprite_name = null,
		vframes = 1,
		width = 0
	}
	print(object.parent)
	object.blocks_container.name = self.name + "_blocks_container"
	
	if randomize_seed: randomize()

	if not self is RigidBody2D:
		print("ERROR: The '%s' node must be a 'RigidBody2D'" % self.name)
		object.can_detonate = false
		return

	for child in get_children():
		if child is Sprite:
			object.sprite_name = child.name

	if not object.sprite_name:
		print("ERROR: The 'RigidBody2D' (%s) must contain at least a 'Sprite'" % self.name)
		object.can_detonate = false
		return

	if object.blocks_per_side > 10:
		print("ERROR: Too many blocks in '%s'! The maximum is 10 blocks per side." % self.name)
		object.can_detonate = false
		return

	if object.blocks_per_side % 2 != 0:
		print("ERROR: 'blocks_per_side' in '%s' must be an even number!" % self.name)
		object.can_detonate = false
		return

	# Set the debris timer.
	object.debris_timer.connect("timeout", self ,"OnExplosionTimeOut") 
	object.debris_timer.set_one_shot(true)
	object.debris_timer.set_wait_time(object.debris_max_time)
	object.debris_timer.name = "debris_timer"
	add_child(object.debris_timer, true)

	# Use vframes and hframes to divide the sprite.
	get_node(object.sprite_name).vframes = object.blocks_per_side
	get_node(object.sprite_name).hframes = object.blocks_per_side
	object.vframes = object.blocks_per_side
	object.hframes = object.blocks_per_side

#	var spriteScale = get_node(object.sprite_name).scale
#	if spriteScale.x != 1.0:
#		object.width = spriteScale.x * get_node(object.sprite_name).texture.get_width()
#		object.height = spriteScale.y * get_node(object.sprite_name).texture.get_height()
#	else:
	object.width = float(get_node(object.sprite_name).texture.get_width())
	object.height = float(get_node(object.sprite_name).texture.get_height())

	# Check if the sprite is centered to get the offset.
	if get_node(object.sprite_name).centered:
		object.offset = Vector2(object.width / 2, object.height / 2)

	for n in range(object.vframes * object.hframes):
		# Duplicate the object.
		var duplicated_object = self.duplicate(8)
		# Add a unique name to each block.
		duplicated_object.name = self.name + "_block_" + str(n)
		# Append it to the blocks array.
		object.blocks.append(duplicated_object)

		object.blocks[n].set_script(null)
		object.blocks[n].set_mode(MODE_STATIC)
		object.blocks[n].get_node(object.sprite_name).vframes = object.vframes
		object.blocks[n].get_node(object.sprite_name).hframes = object.hframes
		object.blocks[n].get_node(object.sprite_name).frame = n

	# Position each block in place to create the whole sprite.
	for x in range(object.hframes):
		for y in range(object.vframes):
			object.blocks[object.frame].position = Vector2(\
				y * (object.width / object.hframes) - object.offset.x + position.x,\
				x * (object.height / object.vframes) - object.offset.y + position.y)

			object.frame += 1

	call_deferred("add_children", object)

func DestroyObject():
	if object.can_detonate:
		object.detonate = true

func _physics_process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and object.can_detonate:
		object.detonate = true

	if object.can_detonate and object.detonate:
		detonate()

func _integrate_forces(state):
	explosion(state.step)

func add_children(child_object):
	for i in range(child_object.blocks.size()):
		child_object.blocks_container.add_child(child_object.blocks[i], true)

	child_object.parent.add_child(child_object.blocks_container, true)

	# Move the self element faaaar away, instead of removing it,
	# so we can still use the script and its functions.
	self.position = Vector2(-999999, -999999)
#	self.queue_free()

func detonate():
	object.can_detonate = false
	object.has_detonated = true

	for i in range(object.blocks_container.get_child_count()):
		var child = object.blocks_container.get_child(i)

		var child_gravity_scale = blocks_gravity_scale
		child.gravity_scale = child_gravity_scale

		var child_scale = rand_range(0.5, 1.5)
		child.get_node(object.sprite_name).scale *= Vector2(child_scale, child_scale)

		child.mass = child_scale

		child.z_index = 1 if randf() < 0.5 else 0
		child.set_mode(MODE_RIGID)

	object.debris_timer.start()


func explosion(delta):
	if object.detonate:
		for i in range(object.blocks_container.get_child_count()):
			var child = object.blocks_container.get_child(i)
			child.apply_central_impulse(Vector2(rand_range(-blocks_impulse, blocks_impulse), -blocks_impulse))

		if explosion_delay:
			explosion_delay_timer_limit = delta
			explosion_delay_timer += delta
			if explosion_delay_timer > explosion_delay_timer_limit:
				explosion_delay_timer -= explosion_delay_timer_limit
				object.detonate = false
		else:
			object.detonate = false


func OnExplosionTimeOut():
	for i in range(object.blocks_container.get_child_count()):
		var child = object.blocks_container.get_child(i)
	
		var fadeOutPiecesDuration = rand_range(0.0, 0.4)
		
		var opacity_tween = Tween.new()
		opacity_tween.connect("tween_completed", self, "OnOpacityTweenComplete")
		opacity_tween.interpolate_property(
			child, "modulate:a", 1.0, 0.0, fadeOutPiecesDuration)
		add_child(opacity_tween, true)
		opacity_tween.start()
		
		#We wait for all pieces to be destroyed
		var timer = Timer.new()
		self.add_child(timer)
		timer.one_shot = true
		timer.connect("timeout", self, "QueueFreeContainers")
		timer.start(fadeOutPiecesDuration + 0.15)
		
func OnOpacityTweenComplete(obj, _key):
	obj.queue_free()
	
func QueueFreeContainers():
	object.blocks_container.queue_free()
	self.queue_free()
