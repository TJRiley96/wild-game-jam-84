extends Node2D

@onready var critter_builder: CritterBuilder = $CharacterBug

var current_stage: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	critter_builder.stage_index = 0
	current_stage = critter_builder.stage_index
	critter_builder.complete_stage(current_stage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_creator_area_entered(area: Area2D) -> void:
	if area.get_parent() is Card:
		var card: Card = area.get_parent()
		card.card_bg.hide()


func _on_creator_area_exited(area: Area2D) -> void:
	if area.get_parent() is Card:
		var card: Card = area.get_parent()
		card.card_bg.show()

func set_part() -> void:
	critter_builder.complete_stage(current_stage)
	if current_stage != critter_builder.stage_index:
		current_stage = critter_builder.stage_index
	else:
		print("Invalid part set")
	
