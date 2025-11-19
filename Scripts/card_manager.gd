extends Node2D
const COLLISON_MASK_CARD: int = 1
var card_being_drag: Card
var screen_size
var screen_offset: int = 16

const starting_card_slot: Vector2 = Vector2(180.0, 540.0)
const CARD_SLOT_POS_OFFESET: float = 120.0

var card_slots: Array[CardSlot] = []
var cards: Array[Card] = []

var current_stage: int = 0

@export var card_slot_amount: int = 3
@export var cards_amount: int = 2
@export var card_type: Constants.CARD_TYPES = Constants.CARD_TYPES.BODY

@export var init_body_cards: int = 2
@export var init_head_cards: int = 3
@export var init_leg_cards: int = 6

@onready var card_row: Node2D = $CardRow

@onready var card_slot_scene: PackedScene = preload("res://Scenes/card_slot.tscn")
@onready var card_scene: PackedScene = preload("res://Scenes/Card/card.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			card_being_drag = raycast_card_check()
			print(card_being_drag)
		else:
			if card_being_drag != null:
				card_being_drag.card_grab = false
			card_being_drag = null

func raycast_card_check():
	var space_state = get_viewport().world_2d.direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_viewport().get_mouse_position()
	params.collide_with_areas = true
	params.collision_mask = COLLISON_MASK_CARD
	var result = space_state.intersect_point(params)
	if result:
		var body = result[0].collider.get_parent()
		if body.is_in_group('Card'):
			return body
			
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	for i in range(0,card_slot_amount):
		create_card_slots()
	#for i in range(cards_amount):
		#get_rand_card(card_type)
	#load_card_slots()
	
	current_stage = Globals.stage_index
	
	pass # Replace with function body.
	# TODO: Add cards to card slots


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_drag:
		card_being_drag.card_grab = true
		var mouse_pos = get_global_mouse_position()
		card_being_drag.global_position = Vector2(clamp(mouse_pos.x, 0+screen_offset, screen_size.x-screen_offset), 
			clamp(mouse_pos.y, 0+(screen_offset*2), screen_size.y-(screen_offset*2)))
			
	if current_stage != Globals.stage_index:
		clear_cards()
		current_stage = Globals.stage_index
		stage_level(current_stage)
		load_card_slots()

func load_card_slots() -> void:
	for i in range(len(cards)):
		cards[i].position = card_slots[i].position
		
func clear_cards() -> void:
	print("Cards Clears")
	for card in cards:
		card.queue_free()
		
	cards.clear()
	
func get_rand_card(type: Constants.CARD_TYPES, num_card: int = 0):
	var card_arr: Array[CardInfo] = GlobalCards.cards.get(type, [])
	if card_arr:
		for i in num_card:
			var card_info = card_arr[randi_range(0, len(card_arr)-1)]
			var temp_card: Card = card_scene.instantiate()
			temp_card.card_info = card_info
			card_row.add_child(temp_card, true)
			cards.append(temp_card)
	
	
func create_card_slots() -> void:
	var new_slot:CardSlot = card_slot_scene.instantiate()
	new_slot.global_position = starting_card_slot + Vector2(CARD_SLOT_POS_OFFESET*len(card_slots), 0)
	card_slots.append(new_slot)
	card_row.add_child(new_slot, true)


func add_cards():
	pass
	
func stage_level(stage_index: int):
	match stage_index:
		0: get_rand_card(Constants.CARD_TYPES.NONE, 0)
		1: get_rand_card(Constants.CARD_TYPES.BODY, init_body_cards)
		2: get_rand_card(Constants.CARD_TYPES.HEAD, init_head_cards)
		3: get_rand_card(Constants.CARD_TYPES.LEG, init_leg_cards)
		4: get_rand_card(Constants.CARD_TYPES.NONE)

	
