extends Node

enum CARD_TYPES{
	NONE,
	BODY,
	LEG,
	HEAD,
	WEAPON,
	ATTACK,
} 

enum STAGE{
	CLEAR,
	BODY,
	HEAD,
	LEGS,
	WEAPON,
	ATTACK,
}

var bug_data_set_template: Dictionary = {
	'card': {
		'body': null,
		'head': null,
		'left_leg_1': null,
		'left_leg_2': null,
		'left_leg_3': null,
		'right_leg_1': null,
		'right_leg_2': null,
		'right_leg_3': null,
		'weapon': null,
		'special': null,
		
	},
	'card_info': {
		'body': null,
		'head': null,
		'left_leg_1': null,
		'left_leg_2': null,
		'left_leg_3': null,
		'right_leg_1': null,
		'right_leg_2': null,
		'right_leg_3': null,
		'weapon': null,
		'special': null,
	},
}
