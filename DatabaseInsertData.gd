extends Node
	
enum BindType { DOUBLE, INT, TEXT }

var race_data_types = [TEXT]
var race_data = [
	["Human"],
	["Vampire"]
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

var itemclass_data_types = [TEXT]
var itemclass_data = [
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