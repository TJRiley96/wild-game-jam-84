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
var head_card_ref: Card = null
var body_card_ref: Card = null

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
	
func set_part(area: Area2D, part: Sprite2D, card_info: CardInfo, card_type: Constants.CARD_TYPES = Constants.CARD_TYPES.NONE):
	if area.get_parent() is Card:
		var card: Card = area.get_parent()
		var selector: Sprite2D = part.find_child("Selector")
		var col: CollisionShape2D = part.find_child("CollisonShape2D")
		card_info = card.card_info
		if card_info.card_type == card_type:
			print("Card Object: ", card.card_info.card_name)
			selector.hide()
			col.disabled = true
			#if not card.card_grab:
			card.critter_part.hide()
			card.global_position = selector.global_position
			print("Card Set: ", card_info, " | Body: ", body_card)
			part.texture = card_info.part_image
			return card.card_info
	return null
			
func clear_part(area: Area2D, part: Sprite2D, card_info: CardInfo):
	if area.get_parent() is Card and card_info:
		var card: Card = area.get_parent()
		var selector: Sprite2D = part.find_child("Selector")
		selector.show()
		if card.card_grab:
			card.critter_part.show()
			card_info = null
			part.texture = null
			return null
		return card_info
			
func clear_stages() -> void:
	body_selected = false
	head_selected = false
	legs_selected = false
	
	left_leg_1.hide()
	left_leg_1.texture = null
	left_card_1 = null
	left_leg_2.hide()
	left_leg_2.texture = null
	left_card_2 = null
	left_leg_3.hide()
	left_leg_3.texture = null
	left_card_3 = null
	
	right_leg_1.hide()
	right_leg_1.texture = null
	right_card_1 = null
	right_leg_2.hide()
	right_leg_2.texture = null
	right_card_2 = null
	right_leg_3.hide()
	right_leg_3.texture = null
	right_card_3 = null
	
	head.hide()
	head.texture = null
	head_card = null
	body.show()
	body.texture = null
	body_card = null
	
	stage_index = 1
	
func stage_body_complete() -> void:
	print("Stage Status: ", check_stage(Constants.STAGE.BODY), " Part Status: ", (body_card != null))
	if check_stage(Constants.STAGE.BODY) and body_card != null:
		print("Move to stage 2")
		body_selected = true
		# Delete body Card obj
		#body_card_ref.queue_free()
		stage_index += 1
		head.show()
		
func stage_head_complete() -> void:
	print("Stage Status: ", check_stage(Constants.STAGE.HEAD), " Part Status: ", (head_card != null))
	if check_stage(Constants.STAGE.HEAD) and head_card != null:
		head_selected = true
		stage_index += 1
		# Delete head Card obj
		#head_card_ref.queue_free()
		
		# Show leg drag points
		left_leg_1.show()
		left_leg_2.show()
		left_leg_3.show()
		right_leg_1.show()
		right_leg_2.show()
		right_leg_3.show()
		
func stage_leg_complete() -> void:
	if check_stage(Constants.STAGE.LEGS):
		legs_selected = true
		stage_index += 1

func complete_stage(index: int) -> void:
	match index:
		0: clear_stages()
		1: stage_body_complete()
		2: stage_head_complete()
		3: stage_leg_complete()
		_: complete_stage(0)
		
func validate_stage() -> void:
	pass
	
func check_stage(index: Constants.STAGE) -> bool:
	match index:
		Constants.STAGE.BODY: return(!body_selected and !head_selected and !legs_selected)
		Constants.STAGE.HEAD: return(body_selected and !head_selected and !legs_selected)
		Constants.STAGE.LEGS: return(body_selected and head_selected and !legs_selected)
		Constants.STAGE.WEAPON: return(body_selected and head_selected and legs_selected)
		_: return false

# Stage Body
# Body Part Area2D
func _on_body_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.BODY):
		body_card = set_part(area, body, body_card, Constants.CARD_TYPES.BODY)
		print(body_card)


func _on_body_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.BODY):
		body_card = clear_part(area, body, body_card)

# Stage Head
# Head Part Area2D
func _on_head_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.HEAD):
		head_card = set_part(area, head, head_card, Constants.CARD_TYPES.HEAD)


func _on_head_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.HEAD):
		head_card = clear_part(area, head, head_card)
				
# Stage Leg
# TODO: Add Leg Logic
func _on_ll_1_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_1 = set_part(area, left_leg_1, left_card_1, Constants.CARD_TYPES.LEG)


func _on_ll_1_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_1 = clear_part(area, left_leg_1, left_card_1)
		

func _on_ll_2_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_2 = set_part(area, left_leg_2, left_card_2, Constants.CARD_TYPES.LEG)


func _on_ll_2_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_2 = clear_part(area, left_leg_2, left_card_2)
		
		
func _on_ll_3_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_1 = set_part(area, left_leg_3, left_card_3, Constants.CARD_TYPES.LEG)


func _on_ll_3_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_3 = clear_part(area, left_leg_3, left_card_3)
		
		
func _on_rl_1_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_1 = set_part(area, right_leg_1, right_card_1, Constants.CARD_TYPES.LEG)


func _on_rl_1_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_1 = clear_part(area, right_leg_1, right_card_1)
		

func _on_rl_2_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_2 = set_part(area, right_leg_2, right_card_2, Constants.CARD_TYPES.LEG)


func _on_rl_2_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_2 = clear_part(area, right_leg_2, right_card_2)
		

func _on_rl_3_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_3 = set_part(area, right_leg_3, right_card_3, Constants.CARD_TYPES.LEG)


func _on_rl_3_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_3 = clear_part(area, right_leg_3, right_card_3)
