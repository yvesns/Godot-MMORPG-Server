extends Node

var SQLite
#var SQLite = preload("res://lib/gdsqlite.gdns")
var db
var dbFile = "res://database.sql"

enum BindType { DOUBLE, INT, TEXT }

func _ready():
	pass

func init_database():
	SQLite = load("res://lib/gdsqlite.gdns")
	var result = null
	
	db = SQLite.new()
	
	if (!db.open(dbFile)):
		print("Failed to open database.")
		return
		
	print(db.simple_query(DatabaseQueries.create_user_table()))
	
	print(db.query(DatabaseQueries.insert_user()), ["test", str("test".hash())], [TEXT, TEXT])
	
func has_user(user):
	pass