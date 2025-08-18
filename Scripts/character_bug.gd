extends CharacterBody2D

@export var speed: float = 300.0
const JUMP_VELOCITY = -400.0

const RIGHT_LEG_MIN_RANGE: float = -20.0
const RIGHT_LEG_MAX_RANGE: float = -160.0

const LEFT_LEG_MIN_RANGE: float = 20.0
const LEFT_LEG_MAX_RANGE: float = 160.0

# Parts
@export var head_card: CardInfo
@export var body_card: CardInfo
@export var weapon_card: CardInfo
@export var combat_style: CardInfo
@export var top_left_card: CardInfo
@export var top_right_card: CardInfo
@export var bot_left_card: CardInfo
@export var bot_right_card: CardInfo


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


func load_parts() -> void:
	pass

func _ready() -> void:
	top_leg_left.rotation_degrees = randf_range(LEFT_LEG_MIN_RANGE,LEFT_LEG_MAX_RANGE)
	bot_leg_left.rotation_degrees = randf_range(LEFT_LEG_MIN_RANGE,LEFT_LEG_MAX_RANGE)
	
	top_leg_right.rotation_degrees = randf_range(RIGHT_LEG_MIN_RANGE, RIGHT_LEG_MAX_RANGE)
	bot_leg_right.rotation_degrees = randf_range(RIGHT_LEG_MIN_RANGE, RIGHT_LEG_MAX_RANGE)

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
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y= move_toward(velocity.y, 0, speed)
		
	if velocity:
		print("Forward Velocity")
		rotate_left_legs()
		rotate_right_legs()

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
	# Top Right Leg
	if reset_top_r:
		top_leg_right.rotation_degrees -= 10# Magic numbers
		reset_top_r = false if top_leg_right.rotation_degrees <= RIGHT_LEG_MAX_RANGE else true
	else:
		top_leg_right.rotation_degrees += 5
		reset_top_r = true if top_leg_right.rotation_degrees >= RIGHT_LEG_MIN_RANGE else false
	
	# Bot Right Leg
	if reset_bot_r:
		bot_leg_right.rotation_degrees -= 10# Magic numbers
		reset_bot_r = false if bot_leg_right.rotation_degrees <= RIGHT_LEG_MAX_RANGE else true
	else:
		bot_leg_right.rotation_degrees += 5
		reset_bot_r = true if bot_leg_right.rotation_degrees >= RIGHT_LEG_MIN_RANGE else false
