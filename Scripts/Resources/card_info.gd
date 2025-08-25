class_name CardInfo extends Resource


@export var name: StringName

@export_category("Card General")
@export var type: Constants.CARD_TYPES = Constants.CARD_TYPES.NONE
@export var part_image: Texture
@export var part_scene: PackedScene


@export_category("Card Stats")
@export_range(-5, 5, 1) var health = 0
@export_range(-5, 5, 1) var strength = 0
@export_range(-5, 5, 1) var speed = 0
@export_range(-5, 5, 1) var thorns = 0
@export_range(-5, 5, 1) var armor = 0
@export_range(-5, 5, 1) var attack_speed = 0
