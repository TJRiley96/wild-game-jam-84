extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is Card:
		var card: Card = body
		card.card_bg.hide()


func _on_body_exited(body: Node2D) -> void:
	print(body)
	if body is Card:
		var card: Card = body
		card.card_bg.show()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Card:
		var card: Card = area.get_parent()
		card.card_bg.hide()


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is Card:
		var card: Card = area.get_parent()
		card.card_bg.show()
