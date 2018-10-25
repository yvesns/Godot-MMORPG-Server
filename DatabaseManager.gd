extends Node

# TODO
# 1. Create a separate query to initialize the tables

var SQLite
var db
var db_file = "res://database.sql"

enum BindType { DOUBLE, INT, TEXT }

func _ready():
	pass

func init_database():
	SQLite = load("res://lib/gdsqlite.gdns")
	var result = null
	
	#Just for testing, remove later.
	Directory.new().remove("res://database.sql")
	
	db = SQLite.new()
	
	if (!db.open(db_file)):
		print("Failed to open database.")
		return
	
	init_tables()
	
	#Remove later.
	run_tests()
	
func init_tables():
	print(db.simple_query(DatabaseQueries.create_player_table()))
	print(db.simple_query(DatabaseQueries.create_race_table()))
	print(db.simple_query(DatabaseQueries.create_class_table()))
	print(db.simple_query(DatabaseQueries.create_player_character_table()))
	
	# TODO: put these insertions in a separate query
	db.query(DatabaseQueries.insert_race(), ["Human"], [TEXT])
	db.query(DatabaseQueries.insert_race(), ["Vampire"], [TEXT])
	
	db.query(DatabaseQueries.insert_class(), ["CommonHuman", "Human"], [TEXT, TEXT])
	db.query(DatabaseQueries.insert_class(), ["Fighter", "Human"], [TEXT, TEXT])
	db.query(DatabaseQueries.insert_class(), ["Mage", "Human"], [TEXT, TEXT])
	db.query(DatabaseQueries.insert_class(), ["Healer", "Human"], [TEXT, TEXT])
	
	db.query(DatabaseQueries.insert_class(), ["CommonVampire", "Vampire"], [TEXT, TEXT])
	db.query(DatabaseQueries.insert_class(), ["Blood Seeker", "Vampire"], [TEXT, TEXT])
	db.query(DatabaseQueries.insert_class(), ["Strigoi", "Vampire"], [TEXT, TEXT])
	
func run_tests():
	var character_class = preload("res://Classes/Player/PlayerCharacter.gd")
	
	var char1 = character_class.new()
	char1.set_name("TestCharacter")
	char1.set_race("Human")
	char1.set_class("CommonHuman")
	
	var char2 = character_class.new()
	char2.set_name("TestCharacter2")
	char2.set_race("Vampire")
	char2.set_class("Blood Seeker")
	
	print(insert_player("test", "test".hash(), "mail"))
	print(insert_player_character("test", char1))
	print(insert_player_character("test", char2))
	print(db.fetch_assoc(DatabaseQueries.select_player(), ["test"], [TEXT]))
	print(has_player("test"))
	print(has_email("mail"))
	
##########
# Player #
##########
	
func has_player(player):
	return db.fetch_assoc(DatabaseQueries.select_player(), [player], [TEXT]).size() > 0
	
func has_email(email):
	return db.fetch_assoc(DatabaseQueries.select_player("email"), [email], [TEXT]).size() > 0
	
func insert_player(login, password, email):
	return db.query(DatabaseQueries.insert_player(), [login, password, email], [TEXT, INT, TEXT])
	
func get_player(player):
	return db.fetch_assoc(DatabaseQueries.select_player(), [player], [TEXT])
	
####################
# Player character #
####################

func has_character(character):
	return db.fetch_assoc(DatabaseQueries.select_player_character(), [character], [TEXT]).size() > 0
	
func insert_player_character(player, character):
	var info = [character.get_name(), player, character.get_race(), character.get_class()]
	
	return db.query(DatabaseQueries.insert_player_character(), info, [TEXT, TEXT, TEXT, TEXT])
	
func get_characters(player):
	return db.fetch_assoc(DatabaseQueries.select_player_characters(), [player], [TEXT])
	
func get_character(character):
	return db.fetch_assoc(DatabaseQueries.select_player_character(), [character], [TEXT])
	
func delete_character(character_name):
	return db.query(DatabaseQueries.delete_player_character(), [character_name], [TEXT])
	
#########
# Class #
#########

func get_class(character_class):
	return db.fetch_assoc(DatabaseQueries.select_class(), [character_class], [TEXT])