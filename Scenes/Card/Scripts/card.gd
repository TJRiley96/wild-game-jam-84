@tool
class_name Card extends Node2D


@onready var card_bg: Sprite2D = $BG
@onready var critter_part: Sprite2D = $SpritePart
@onready var part_name: Label = $PartName

@export var card_info: CardInfo = preload("res://Scripts/Resources/card_example.tres")

@export var load_file: bool = false: 
	set(value):
		if Engine.is_editor_hint():	
			load_card_info()
			load_file=false
	

var card_grab: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_card_info()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_card_info() -> void:
	print("Load Card")
	critter_part.scale = Vector2(1,1)
	critter_part.texture = card_info.part_image
	critter_part.rotation_degrees = 45
	
	if card_info.card_type == Constants.CARD_TYPES.BODY:
		critter_part.scale *= 1
	if card_info.card_type == Constants.CARD_TYPES.HEAD:
		critter_part.scale *= 2.5
	
	
	part_name.text = card_info.card_name
	
