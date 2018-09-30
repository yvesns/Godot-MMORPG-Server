extends Node

var user_table = "GameUser"

func create_user_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + user_table + " (";
	query += "login text PRIMARY KEY,";
	query += "password_hash integer NOT NULL,";
	query += "email text UNIQUE NOT NULL";
	query += ");";
	
	return query
	
func insert_user(): 
	return "INSERT INTO " + user_table + "(login, password_hash, email) VALUES(?,?,?);"
	
func select_user(function = ""):
	if function == "":
		return "SELECT * FROM " + user_table + " WHERE login = ?;"
		
	if (function == "has_email" ||
	    function == "email"):
		return "SELECT * FROM " + user_table + " WHERE email = ?;"