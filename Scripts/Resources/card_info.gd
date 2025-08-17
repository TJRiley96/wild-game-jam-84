class_name CardInfo extends Resource


@export var name: StringName

@export_category("Card Images")
@export var part_image: Texture

@export_category("Card Stats")
@export_range(-5, 5, 1) var health = 0
@export_range(-5, 5, 1) var strength = 0
@export_range(-5, 5, 1) var speed = 0
@export_range(-5, 5, 1) var thorns = 0
@export_range(-5, 5, 1) var armor = 0
@export_range(-5, 5, 1) var attack_speed = 0
