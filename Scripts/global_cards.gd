extends Node

var cards: Dictionary ={
	'heads': [],
	'bodies': [],
	'legs': [],
	'weapons': [],
}
var card_folder_path: String = "res://Cards/"

func _ready() -> void:
	cards['heads'] = get_cards_from_folder(card_folder_path+"Heads/")
	cards['bodies'] = get_cards_from_folder(card_folder_path+"Body/")

func get_cards_from_folder(path: String) -> Array[CardInfo]:
	var temp_arr: Array[CardInfo] = []
	for file in DirAccess.get_files_at(path):
		temp_arr.append(load(path+file))
	return temp_arr
	
