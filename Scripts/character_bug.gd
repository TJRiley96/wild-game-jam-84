@tool
class_name CritterBuilder extends Node2D

@export var speed: float = 300.0
const JUMP_VELOCITY = -400.0

const RIGHT_LEG_MIN_RANGE: float = -20.0
const RIGHT_LEG_MAX_RANGE: float = -160.0

const LEFT_LEG_MIN_RANGE: float = 20.0
const LEFT_LEG_MAX_RANGE: float = 160.0

# Parts
@export_category("Parts Card")
@export_group("Main Body Cards")
@export var head_card: CardInfo = null
@export var body_card: CardInfo = null

@export_group("Left Leg Cards")
@export var left_card_1: CardInfo = null
@export var left_card_2: CardInfo = null
@export var left_card_3: CardInfo = null

@export_group("Right Leg Cards")
@export var right_card_1: CardInfo = null
@export var right_card_2: CardInfo = null
@export var right_card_3: CardInfo = null

@export_group("Combat Cards")
@export var weapon_card: CardInfo = null
@export var combat_style: CardInfo = null

# Body
@onready var body: Sprite2D = $Parts/Body

# Head
@onready var head: Sprite2D = $Parts/Head

# Legs
@onready var left_leg_1: Sprite2D = $Parts/LeftLeg1
@onready var left_leg_2: Sprite2D = $Parts/LeftLeg2
@onready var left_leg_3: Sprite2D = $Parts/LeftLeg3
@onready var right_leg_1: Sprite2D = $Parts/RightLeg1
@onready var right_leg_2: Sprite2D = $Parts/RightLeg2
@onready var right_leg_3: Sprite2D = $Parts/RightLeg3

var body_selected: bool = false		# Stage 0
var head_selected: bool = false		# Stage 1
var legs_selected: bool = false		# Stage 2

var stage_index: int = 0			# Stage 3 means completed bug

func setup_builder() -> void:
	pass

func create_bug() -> void:
	pass
	
func load_parts() -> void:
	pass
	
func set_part(area: Area2D, part: Sprite2D, card_info: CardInfo, type: Constants.CARD_TYPES = Constants.CARD_TYPES.NONE):
	if area.get_parent() is Card:
		var card: Card = area.get_parent()
		var selector: Sprite2D = part.find_child("Selector")
		selector.hide()
		#if not card.card_grab:
		card.critter_part.hide()
		card.global_position = selector.global_position
		card_info = card.card_info
		part.texture = card_info.part_image
			
func clear_part(area: Area2D, part: Sprite2D, card_info: CardInfo):
	if area.get_parent() is Card:
		var card: Card = area.get_parent()
		var selector: Sprite2D = part.find_child("Selector")
		selector.show()
		if card.card_grab:
			card.critter_part.show()
			card_info = null
			part.texture = null
			
func clear_stages() -> void:
	body_selected = false
	head_selected = false
	legs_selected = false
	
	left_leg_1.hide()
	left_leg_2.hide()
	left_leg_3.hide()
	
	right_leg_1.hide()
	right_leg_2.hide()
	right_leg_3.hide()
	
	head.hide()
	body.show()
	
	stage_index = 1
	
func stage_one() -> void:
	if body_card != null:
		body_selected = true
		stage_index += 1
		
func stage_two() -> void:
	if check_stage(2) and head_card != null:
		head_selected = true
		stage_index += 1	
		
func stage_three() -> void:
	if check_stage(3):
		legs_selected = true
		stage_index += 1

func complete_stage(index: int) -> void:
	match index:
		0: clear_stages()
		1: stage_one()
		2: stage_two()
		3: stage_three()
		_: complete_stage(0)
		
func validate_stage() -> void:
	pass
	
func check_stage(index: int) -> bool:
	match index:
		0: return(!body_selected and !head_selected and !legs_selected)
		1: return(body_selected and !head_selected and !legs_selected)
		2: return(body_selected and head_selected and !legs_selected)
		3: return(body_selected and head_selected and legs_selected)
		_: return false

# Stage One	 
# Body Part Area2D
func _on_body_area_entered(area: Area2D) -> void:
	if check_stage(0):
		set_part(area, body, body_card)


func _on_body_area_exited(area: Area2D) -> void:
	if check_stage(0):
		clear_part(area, body, body_card)

# Stage Two
# Head Part Area2D
func _on_head_area_entered(area: Area2D) -> void:
	if check_stage(1):
		set_part(area, head, head_card)

func _on_head_area_exited(area: Area2D) -> void:
	if check_stage(1):
		clear_part(area, head, head_card)
