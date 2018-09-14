extends Node

var user_table = "GameUser"

func create_user_table():
	var query = ""
	
	query = "CREATE TABLE IF NOT EXISTS " + user_table + " (";
	query += "id integer PRIMARY KEY,";
	query += "login text NOT NULL,";
	query += "password_hash integer NOT NULL,";
	query += ");";
	
	return query