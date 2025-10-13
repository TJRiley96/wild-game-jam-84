extends Node2D
const COLLISON_MASK_CARD: int = 1
var card_being_drag: Card
var screen_size
var screen_offset: int = 16

const starting_card_slot: Vector2 = Vector2(180.0, 540.0)
const CARD_SLOT_POS_OFFESET: float = 120.0

var card_slots: Array[CardSlot] = []

@export var card_slot_amount: int = 3

@onready var card_row: Node2D = $CardRow

@onready var card_slot_scene: PackedScene = preload("res://Scenes/card_slot.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			print("Left Pressed")
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
	pass # Replace with function body.
	# TODO: Add cards to card slots


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_drag:
		card_being_drag.card_grab = true
		var mouse_pos = get_global_mouse_position()
		card_being_drag.global_position = Vector2(clamp(mouse_pos.x, 0+screen_offset, screen_size.x-screen_offset), 
			clamp(mouse_pos.y, 0+(screen_offset*2), screen_size.y-(screen_offset*2))) 


func load_card_slots() -> void:
	pass
	
func create_card_slots() -> void:
	var new_slot:CardSlot = card_slot_scene.instantiate()
	new_slot.global_position = starting_card_slot + Vector2(CARD_SLOT_POS_OFFESET*len(card_slots), 0)
	card_slots.append(new_slot)
	card_row.add_child(new_slot)


	
