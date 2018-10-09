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
		
	print(db.simple_query(DatabaseQueries.create_player_table()))
	print(db.simple_query(DatabaseQueries.create_player_character_table()))
	
	#Remove later.
	run_tests()
	
func run_tests():
	print(insert_player("test", "test".hash(), "mail"))
	print(insert_player_character("TestCharacter", "test"))
	print(insert_player_character("TestCharacter2", "test"))
	print(insert_player_character("TestCharacter3", "test"))
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
	
func insert_player_character(character_name, player):
	return db.query(DatabaseQueries.insert_player_character(), [character_name, player], [TEXT, TEXT])
	
func get_characters(player):
	return db.fetch_assoc(DatabaseQueries.select_player_characters(), [player], [TEXT])