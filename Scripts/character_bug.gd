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

@export var data_set: Dictionary = Constants.bug_data_set_template.duplicate(true)

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
	
func set_part(area: Area2D, part: Sprite2D, card_key: StringName, card_type: Constants.CARD_TYPES = Constants.CARD_TYPES.NONE):
	if area.get_parent() is Card and data_set['card_info'][card_key] == null:
		var card: Card = area.get_parent()
		var selector: Sprite2D = part.find_child("Selector")
		#var col: CollisionShape2D = part.find_child("CollisionShape2D")
		var card_info = card.card_info
		print("Part enter from " + str(card.name))
		if card_info.card_type == card_type:
			print("Card Object: ", card.card_info.card_name)
			card.card_grab = false
			selector.hide()
			card.selected = true
			card.critter_part.hide()
			card.global_position = selector.global_position
			data_set['card'][card_key] = card
			data_set['card_info'][card_key] = card_info
			print("Card Set: ", card_info, " Grab: ", card.card_grab)
			part.texture = card_info.part_image
			return card.card_info
	return null
			
func clear_part(area: Area2D, part: Sprite2D, card_key: StringName):
	var check : bool = area.get_parent() is Card
	check = (data_set['card_info'][card_key] != null and data_set['card'][card_key] == area.get_parent()) if check else false
	if check:
		var card: Card = area.get_parent()
		var selector: Sprite2D = part.find_child("Selector")
		selector.show()
		#print("Part exit from " + str(card.name))
		if card.card_grab:
			card.critter_part.show()
			card.selected = false
			data_set['card_info'][card_key] = null
			data_set['card'][card_key] = null
			part.texture = null
			print('Part Clear')
			return null
		print('Part Not Clear')
		return data_set['card_info'][card_key]
			
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
	if check_stage(Constants.STAGE.BODY) and data_set['card_info']['body'] != null:
		print("Move to stage 2")
		body_selected = true
		# Delete body Card obj
		#body_card_ref.queue_free()
		stage_index += 1
		head.show()
		
func stage_head_complete() -> void:
	print("Stage Status: ", check_stage(Constants.STAGE.HEAD), " Part Status: ", (head_card != null))
	if check_stage(Constants.STAGE.HEAD) and data_set['card_info']['head'] != null:
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
		body_card = set_part(area, body, 'body', Constants.CARD_TYPES.BODY)
		print(data_set['card']['body'])


func _on_body_area_exited(area: Area2D) -> void:
	print("====== Area Left ======")
	if check_stage(Constants.STAGE.BODY):
		body_card = clear_part(area, body, 'body')
		print(data_set['card']['body'])

# Stage Head
# Head Part Area2D
func _on_head_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.HEAD):
		head_card = set_part(area, head, 'head', Constants.CARD_TYPES.HEAD)


func _on_head_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.HEAD):
		head_card = clear_part(area, head, 'head')
				
# Stage Leg
func _on_ll_1_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_1 = set_part(area, left_leg_1, 'left_leg_1', Constants.CARD_TYPES.LEG)


func _on_ll_1_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_1 = clear_part(area, left_leg_1, 'left_leg_1')
		

func _on_ll_2_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_2 = set_part(area, left_leg_2, 'left_leg_2', Constants.CARD_TYPES.LEG)


func _on_ll_2_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_2 = clear_part(area, left_leg_2, 'left_leg_2')
		
		
func _on_ll_3_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_3 = set_part(area, left_leg_3, 'left_leg_3', Constants.CARD_TYPES.LEG)


func _on_ll_3_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		left_card_3 = clear_part(area, left_leg_3, 'left_leg_3')
		
		
func _on_rl_1_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_1 = set_part(area, right_leg_1, 'right_leg_1', Constants.CARD_TYPES.LEG)


func _on_rl_1_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_1 = clear_part(area, right_leg_1, 'right_leg_1')
		

func _on_rl_2_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_2 = set_part(area, right_leg_2, 'right_leg_2', Constants.CARD_TYPES.LEG)


func _on_rl_2_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_2 = clear_part(area, right_leg_2, 'right_leg_2')
		

func _on_rl_3_area_entered(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_3 = set_part(area, right_leg_3, 'right_leg_3', Constants.CARD_TYPES.LEG)


func _on_rl_3_area_exited(area: Area2D) -> void:
	if check_stage(Constants.STAGE.LEGS):
		right_card_3 = clear_part(area, right_leg_3, 'right_leg_3')
