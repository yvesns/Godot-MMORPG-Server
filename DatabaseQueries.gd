extends Node

var player_table = "Player"
var player_character_table = "PlayerCharacter"
var race_table = "Race"

################
# Player table #
################

func create_player_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + player_table + " (";
	query += "login text PRIMARY KEY,";
	query += "password_hash integer NOT NULL,";
	query += "email text UNIQUE NOT NULL";
	query += ");";
	
	return query
	
func insert_player(): 
	return "INSERT INTO " + player_table + "(login, password_hash, email) VALUES(?,?,?);"
	
func select_player(function = ""):
	if function == "":
		return "SELECT * FROM " + player_table + " WHERE login = ?;"
		
	if (function == "has_email" ||
	    function == "email"):
		return "SELECT * FROM " + player_table + " WHERE email = ?;"
		
##########################
# Player character table #
##########################
	
func create_player_character_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + player_character_table + " (";
	query += "name text PRIMARY KEY,";
	query += "player_fk text NOT NULL,";
	query += "FOREIGN KEY(player_fk) REFERENCES " + player_table + "(artistid)";
	query += ");";
	
	return query
	
func insert_player_character():
	return "INSERT INTO " + player_character_table + "(name, player_fk) VALUES(?,?);"
	
func select_player_character():
	return "SELECT * FROM " + player_character_table + " WHERE name = ?;"
	
func select_player_characters():
	return "SELECT * FROM " + player_character_table + " WHERE player_fk = ?;"
	
##############
# Race table #
##############

func create_race_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + race_table + " (";
	query += "name text PRIMARY KEY";
	query += ");";
	
	return query
	
func insert_race():
	return "INSERT INTO " + race_table + "(name) VALUES(?);"
	
func select_race():
	return "SELECT * FROM " + race_table + " WHERE name = ?;"