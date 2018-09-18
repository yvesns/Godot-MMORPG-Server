extends Node

var user_table = "GameUser"

func get_create_user_table_query():
	var query = ""
	
	query = "CREATE TABLE IF NOT EXISTS " + user_table + " (";
	query += "id integer PRIMARY KEY,";
	query += "login text NOT NULL,";
	query += "password_hash integer NOT NULL,";
	query += ");";
	
	return query