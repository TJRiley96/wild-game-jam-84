class_name PlayerBug extends CharacterBody2D


@export var speed = 50

@export_range(115,165,5) var rotation_max_top: float = 145.0
@export_range(105,165,5) var rotation_min_top: float = 125.0
@export var rotation_leg_offset: float = 45.0


const JUMP_VELOCITY = -400.0

@onready var head: Sprite2D = $Parts/Head
@onready var body: Sprite2D = $Parts/Body

var left_legs: Array[Sprite2D] = []
var left_legs_bool: Array[bool] = []

var right_legs: Array[Sprite2D] = []
var right_legs_bool: Array[bool] = []

var data_set: Dictionary

func _ready() -> void:
	build_arrays()
	var init_rot: float = 95
	# Setup left leg rotation
	for leg in left_legs:
		leg.rotation_degrees = init_rot
		init_rot -= 5
		
	# Setup right leg rotation
	init_rot = -90
	for leg in right_legs:
		leg.rotation_degrees = init_rot
		init_rot += 5
		
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_foward", "move_backward")
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y= move_toward(velocity.y, 0, speed)
		
	var rotation_dir = Input.get_axis("rotate_couter_clockwise", "rotate_clockwise")
	
	rotation_degrees += rotation_dir
	
	if velocity:
		update_legs()

	move_and_slide()
	
func set_data_set(data: Dictionary) -> void:
	data_set = data

func get_data_from_set(key: StringName) -> Texture:
	return data_set[key].part_image if data_set.get(key) else null

func load_parts() -> void:
	if data_set:
		body.texture = data_set['body'].part_image
		head.texture = data_set['body'].part_image
		for i in range(len(left_legs)):
			left_legs[i].texture = get_data_from_set('left_leg_'+ str(i))
			right_legs[i].texture = get_data_from_set('right_leg_'+ str(i))
	else:
		print("data_set not set")

func build_arrays() -> void:
	for i in range(0,2):
		for j in range(1,4):
			if i:
				left_legs.append(get_node("Parts/LeftLeg"+str(j)))
				left_legs_bool.append(true)
			else:
				right_legs.append(get_node("Parts/RightLeg"+str(j)))
				right_legs_bool.append(true)
	print(left_legs, right_legs)

func update_legs() -> void:
	var offset: float
	for i in range(len(left_legs)):
		#print(left_legs[i], left_legs[i].rotation_degrees)
		offset = rotation_leg_offset * i
		if left_legs_bool[i]:
			left_legs[i].rotation_degrees += 1 # TODO: Magic number
			left_legs_bool[i] = left_legs[i].rotation_degrees <= rotation_max_top - offset
		else:
			left_legs[i].rotation_degrees -= 1
			left_legs_bool[i] = left_legs[i].rotation_degrees <= rotation_min_top - offset
			
	#for i in range(len(right_legs)):
		#print(right_legs[i], right_legs[i].rotation_degrees)
		if right_legs_bool[i]:
			right_legs[i].rotation_degrees -= 1 # TODO: Magic number
			right_legs_bool[i] = right_legs[i].rotation_degrees >= -(rotation_max_top - offset)
		else:
			right_legs[i].rotation_degrees += 1
			right_legs_bool[i] = right_legs[i].rotation_degrees >= -(rotation_min_top - offset)
			
		
	
