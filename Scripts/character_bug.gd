extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const RIGHT_LEG_MIN_RANGE: float = 0.0
const RIGHT_LEG_MAX_RANGE: float = -180.0

const LEFT_LEG_MIN_RANGE: float = 20.0
const LEFT_LEG_MAX_RANGE: float = 160.0

# Parts

# Legs
@onready var top_leg_left: Sprite2D = $Parts/TopLegLeft
@onready var top_leg_right: Sprite2D = $Parts/TopLegRight
@onready var bot_leg_left: Sprite2D = $Parts/BotLegLeft
@onready var bot_leg_right: Sprite2D = $Parts/BotLegRight


# Leg direction bools
var reset_top_l: bool = true
var reset_top_r: bool = false
var reset_bot_l: bool = false
var reset_bot_r: bool = true

func _ready() -> void:
	top_leg_left.rotation_degrees = randf_range(0,180)
	bot_leg_left.rotation_degrees = randf_range(0,180)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_foward", "move_backward")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y= move_toward(velocity.y, 0, SPEED)
		
	if velocity:
		print("Forward Velocity")
		rotate_left_legs()
		#rotate_right_legs()

	move_and_slide()


func rotate_left_legs(backward: bool = false) -> void:
	
	# Top Left Leg
	if reset_top_l:
		top_leg_left.rotation_degrees += 10# Magic numbers
		reset_top_l = false if top_leg_left.rotation_degrees >= LEFT_LEG_MAX_RANGE else true
	else:
		top_leg_left.rotation_degrees -= 5
		reset_top_l = true if top_leg_left.rotation_degrees <= LEFT_LEG_MIN_RANGE else false
	
	# Bot Left Leg
	if reset_bot_l:
		bot_leg_left.rotation_degrees += 10# Magic numbers
		reset_bot_l = false if bot_leg_left.rotation_degrees >= LEFT_LEG_MAX_RANGE else true
	else:
		bot_leg_left.rotation_degrees -= 5
		reset_bot_l = true if bot_leg_left.rotation_degrees <= LEFT_LEG_MIN_RANGE else false
	
func rotate_right_legs(backward: bool = false) -> void:
	# Top Left Leg
	if reset_top_l:
		top_leg_left.rotation_degrees += 10# Magic numbers
		reset_top_l = false if top_leg_left.rotation_degrees >= LEFT_LEG_MAX_RANGE else true
	else:
		top_leg_left.rotation_degrees -= 5
		reset_top_l = true if top_leg_left.rotation_degrees <= LEFT_LEG_MIN_RANGE else false
	
	# Bot Left Leg
	if reset_bot_l:
		bot_leg_left.rotation_degrees += 10# Magic numbers
		reset_bot_l = false if bot_leg_left.rotation_degrees >= LEFT_LEG_MAX_RANGE else true
	else:
		bot_leg_left.rotation_degrees -= 5
		reset_bot_l = true if bot_leg_left.rotation_degrees <= LEFT_LEG_MIN_RANGE else false
