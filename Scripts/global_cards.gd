extends Node

var cards: Dictionary ={
	Constants.CARD_TYPES.HEAD: [],
	Constants.CARD_TYPES.BODY: [],
	Constants.CARD_TYPES.LEG: [],
	Constants.CARD_TYPES.WEAPON: [],
}
var card_folder_path: String = "res://Cards/"

func _ready() -> void:
	cards[Constants.CARD_TYPES.HEAD] = get_cards_from_folder(card_folder_path+"Heads/")
	cards[Constants.CARD_TYPES.BODY] = get_cards_from_folder(card_folder_path+"Body/")
	cards[Constants.CARD_TYPES.LEG] = get_cards_from_folder(card_folder_path+"Legs/")

func get_cards_from_folder(path: String) -> Array[CardInfo]:
	var temp_arr: Array[CardInfo] = []
	for file in DirAccess.get_files_at(path):
		temp_arr.append(load(path+file))
	return temp_arr
	
