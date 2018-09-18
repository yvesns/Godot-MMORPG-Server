extends Node

const SQLite = preload("res://lib/gdsqlite.gdns");
var db
var dbFile = "res://database.sql"

func _ready():
	
func init_database():
	var result = null
	
	db = SQLite.new()
	
	if (!db.open_db(dbFile)):
		print("Failed to open database.")
		return
		
	print(db.query(DatabaseQueries.get_create_user_table_query()))
	
func has_user(user):
	pass