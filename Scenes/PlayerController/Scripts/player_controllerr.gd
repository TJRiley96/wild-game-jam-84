extends CharacterBody2D


@export var speed = 50

@export var rotation_max: float = 100.0
@export var rotation_min: float = 80.0
const JUMP_VELOCITY = -400.0

var left_legs: Array[Sprite2D] = []
var left_legs_bool: Array[bool] = []

var right_legs: Array[Sprite2D] = []
var right_legs_bool: Array[bool] = []

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
	
	for i in range(len(left_legs)):
		print(left_legs[i], left_legs[i].rotation_degrees)
		if left_legs_bool[i]:
			left_legs[i].rotation_degrees += 1 # TODO: Magic number
			left_legs_bool[i] = left_legs[i].rotation_degrees <= rotation_max
		else:
			left_legs[i].rotation_degrees -= 1
			left_legs_bool[i] = left_legs[i].rotation_degrees <= rotation_min
			
	for i in range(len(right_legs)):
		print(right_legs[i], right_legs[i].rotation_degrees)
		if right_legs_bool[i]:
			right_legs[i].rotation_degrees -= 1 # TODO: Magic number
			right_legs_bool[i] = right_legs[i].rotation_degrees >= -rotation_max
		else:
			right_legs[i].rotation_degrees += 1
			right_legs_bool[i] = right_legs[i].rotation_degrees >= -rotation_min
			
		
	
