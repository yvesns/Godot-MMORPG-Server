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
	
	#Just for testing, remove later.
	Directory.new().remove("res://database.sql")
	
	db = SQLite.new()
	
	if (!db.open(db_file)):
		print("Failed to open database.")
		return
		
	print(db.simple_query(DatabaseQueries.create_user_table()))
	
	#Just for testing, remove later.
	print(db.query(DatabaseQueries.insert_user(), ["test", str("test".hash()), "mail"], [TEXT, TEXT, TEXT]))
	print(db.fetch_assoc(DatabaseQueries.select_user(), ["test"], [TEXT]))
	
func has_user(user):
	return db.fetch_assoc(DatabaseQueries.select_user(), [user], [TEXT]).size() > 0