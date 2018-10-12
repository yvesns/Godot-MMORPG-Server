extends Node

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
	
	db.query(DatabaseQueries.insert_race(), ["Human"], [TEXT])
	db.query(DatabaseQueries.insert_race(), ["Vampire"], [TEXT])
	
	db.query(DatabaseQueries.insert_class(), ["Fighter", "Human"], [TEXT])
	db.query(DatabaseQueries.insert_class(), ["Mage", "Human"], [TEXT])
	db.query(DatabaseQueries.insert_class(), ["Healer", "Human"], [TEXT])
	
	db.query(DatabaseQueries.insert_class(), ["Blood Seeker", "Vampire"], [TEXT])
	db.query(DatabaseQueries.insert_class(), ["Strigoi", "Vampire"], [TEXT])
	
func run_tests():
	print(insert_player("test", "test".hash(), "mail"))
	print(insert_player_character("TestCharacter", "test", "Human", "Fighter"))
	print(insert_player_character("TestCharacter2", "test", "Vampire", "Blood Seeker"))
	print(insert_player_character("TestCharacter3", "test", "Vampire", "Strigoi"))
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
	
func insert_player_character(character_name, player, race, character_class):
	return db.query(DatabaseQueries.insert_player_character(), [character_name, player, race, character_class], [TEXT, TEXT, TEXT, TEXT])
	
func get_characters(player):
	return db.fetch_assoc(DatabaseQueries.select_player_characters(), [player], [TEXT])