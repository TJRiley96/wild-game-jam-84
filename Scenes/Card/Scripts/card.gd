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
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_card_info() -> void:
	print("Load Card")
	critter_part.texture = card_info.part_image
	critter_part.rotation_degrees = 45
	
	part_name.text = card_info.name
	
