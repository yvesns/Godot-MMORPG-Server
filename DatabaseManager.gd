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
	
	#Remove later.
	run_tests()
	
func run_tests():
	print(insert_user("test", str("test".hash()), "mail"))
	print(db.fetch_assoc(DatabaseQueries.select_user(), ["test"], [TEXT]))
	print(has_user("test"))
	print(has_email("mail"))
	
func has_user(user):
	return db.fetch_assoc(DatabaseQueries.select_user(), [user], [TEXT]).size() > 0
	
func has_email(email):
	return db.fetch_assoc(DatabaseQueries.select_user("email"), [email], [TEXT]).size() > 0
	
func insert_user(user, password, email):
	return db.query(DatabaseQueries.insert_user(), [user, password, email], [TEXT, TEXT, TEXT])