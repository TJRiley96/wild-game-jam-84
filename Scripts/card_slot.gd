class_name CardSlot extends Node2D


var card_obj: Card = null
var is_empty: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_obj:
		if not card_obj.card_grab:
			card_obj.global_position = global_position
			is_empty = false


func _on_card_slot_area_entered(area: Area2D) -> void:
	print("Card Enter")
	if area.get_parent() is Card and is_empty:
		card_obj = area.get_parent()
		print("Card set")
	
	if area.get_parent() is Card and not is_empty:
		if area.get_parent() == card_obj:
			card_obj = area.get_parent()


func _on_card_slot_area_exited(area: Area2D) -> void:
	if area.get_parent() is Card and is_empty:
		card_obj = null
	
	if area.get_parent() is Card and not is_empty:
		if area.get_parent() == card_obj:
			is_empty = true
			card_obj = null
