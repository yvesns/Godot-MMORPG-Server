extends Node

var SQLite
#var SQLite = preload("res://lib/gdsqlite.gdns")
var db
var db_file = "res://database.sql"

enum BindType { DOUBLE, INT, TEXT }

func _ready():
	pass

func init_database():
	SQLite = load("res://lib/gdsqlite.gdns")
	var result = null
	var param_array = Array()
	var param_types = Array()
	
	#Just for testing
	Directory.new().remove("res://database.sql")
	
	db = SQLite.new()
	
	if (!db.open(db_file)):
		print("Failed to open database.")
		return
		
	print(db.simple_query(DatabaseQueries.create_user_table()))
	
	param_array.append("test")
	param_array.append(str("test".hash()))
	param_types.append(TEXT)
	param_types.append(TEXT)
	
	print(db.query(DatabaseQueries.insert_user(), param_array, param_types))
	
	#Testing
	#print(db.fetch_assoc(DatabaseQueries.select_user(), ["test"], [TEXT]))
	var test1 = Array()
	test1.append("test")
	var test2 = Array()
	test2.append(TEXT)
	print(db.fetch_assoc(test1, test2))
	
func has_user(user):
	pass