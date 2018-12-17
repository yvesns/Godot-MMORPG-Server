extends Node
	
enum BindType { DOUBLE, INT, TEXT }

var race_data_type = [TEXT]
var race_data = [
	["Human"],
	["Vampire"]
]

var class_data_type = [TEXT, TEXT]
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