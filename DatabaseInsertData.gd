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

func _ready():
	pass
	
func get_types(table_name):
	return get(table_name.to_lower() + "_data_types")
	
func get_data(table_name):
	return get(table_name.to_lower() + "_data")