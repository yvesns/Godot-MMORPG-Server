extends Node
	
enum BindType { DOUBLE, INT, TEXT }
	
var player_data_types = [TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, INT, INT]
var player_data = []

var map_data_types = [TEXT]
var map_data = []

var race_data_types = [TEXT]
var race_data = [
	["Human"],
	["Vampire"],
	["Common"]
]

var class_data_types = [TEXT, TEXT]
var class_data = [
	["CommonHuman", "Human"],
	["Fighter", "Human"],
	["Mage", "Human"],
	["Healer", "Human"],
	["CommonVampire", "Vampire"],
	["Blood Seeker", "Vampire"],
	["Strigoi", "Vampire"]
]
	
var player_character_data_types = [TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, INT, INT]
var player_character_data = []

var item_class_data_types = [TEXT]
var item_class_data = [
	["Helmet"],
	["Weapon"],
	["Armour"],
	["Ring"],
	["Amulet"],
	["Boots"],
	["Gloves"],
	["Belt"],
	["Shield"]
]

var item_type_data_types = [TEXT, TEXT, TEXT, INT, INT, INT, INT, INT]
var item_type_data = [
	["Kettle Helmet", "Helmet", "Human", 0, 0, 10, 2, 2],
	["Sallet", "Helmet", "Human", 0, 0, 20, 2, 2],
	["Barbuta", "Helmet", "Human", 0, 0, 30, 2, 2],
	["Close Helmet", "Helmet", "Human", 0, 0, 40, 2, 2],
	["Great Helmet", "Helmet", "Human", 0, 0, 50, 2, 2],
	["Leather Armour", "Armour", "Human", 0, 0, 50, 2, 3],
	["Long Sword", "Weapon", "Human", 5, 10, 0, 1, 3],
	["Round Shield", "Shield", "Human", 0, 0, 50, 2, 2]
]

var item_rarity_data_types = [TEXT]
var item_rarity_data = [
	["Normal"],
	["Magic"],
	["Rare"],
	["Legendary"]
]

var item_option_data_types = [TEXT, INT, INT]
var item_option_data = [
	["Increased damage", 1, 10],
	["Increased armour", 1, 10]
]

var item_data_types = [TEXT, TEXT, TEXT, TEXT]
var item_data = []

var inventory_data_types = [TEXT, INT, INT, INT]
var inventory_data = []

func _ready():
	pass
	
func get_types(table_name):
	var types = get(table_name.to_lower() + "_data_types")
	
	if types != null:
		types = types.duplicate()
	
	return types
	
func get_data(table_name):
	var data = get(table_name.to_lower() + "_data")
	
	if data != null:
		data = data.duplicate()
	
	return data