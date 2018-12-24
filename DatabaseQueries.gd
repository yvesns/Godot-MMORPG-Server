extends Node

var player_table = "Player"
var player_character_table = "Player_Character"
var race_table = "Race"
var class_table = "Character_Class"
var map_table = "Map"
var item_table = "Item"
var item_class_table = "Item_Class"
var item_type_table = "Item_Type"
var item_rarity_table = "Item_Rarity"
var item_option_table = "Item_Option"
var inventory_table = "Inventory"

func get_table_list():
	return [
		player_table,
		map_table,
		race_table,
		class_table,
		player_character_table,
		item_class_table,
		item_type_table,
		item_rarity_table,
		item_option_table,
		item_table,
		inventory_table
	]
	
func create(table_name):
	return funcref(self, "create_" + table_name.to_lower() + "_table").call_func()
	
func insert(table_name):
	return funcref(self, "insert_" + table_name.to_lower()).call_func()

################
# Player table #
################

func create_player_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + player_table + " ("
	query += "login text PRIMARY KEY,"
	query += "password_hash integer NOT NULL,"
	query += "email text UNIQUE NOT NULL"
	query += ");"
	
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
	
	query = "CREATE TABLE IF NOT EXISTS " + player_character_table + " ("
	query += "name text PRIMARY KEY,"
	query += "player_fk text NOT NULL,"
	query += "race_fk text NOT NULL,"
	query += "class_fk text NOT NULL,"
	query += "respawn_map_fk text NOT NULL DEFAULT 'TestMap',"
	query += "logout_map_fk text NOT NULL DEFAULT 'TestMap',"
	query += "logout_x integer DEFAULT 0,"
	query += "logout_y integer DEFAULT 0,"
	query += "FOREIGN KEY(player_fk) REFERENCES " + player_table + "(login),"
	query += "FOREIGN KEY(race_fk) REFERENCES " + player_table + "(name),"
	query += "FOREIGN KEY(class_fk) REFERENCES " + class_table + "(name),"
	query += "FOREIGN KEY(respawn_map_fk) REFERENCES " + map_table + "(name),"
	query += "FOREIGN KEY(logout_map_fk) REFERENCES " + map_table + "(name)"
	query += ");"
	
	return query
	
func insert_player_character():
	return "INSERT INTO " + player_character_table + "(name, player_fk, race_fk, class_fk) VALUES(?,?,?,?);"
	
func select_player_character():
	return "SELECT * FROM " + player_character_table + " WHERE name = ?;"
	
func select_player_characters():
	return "SELECT * FROM " + player_character_table + " WHERE player_fk = ?;"
	
func delete_player_character():
	return "DELETE FROM " + player_character_table + " WHERE name = ?;"
	
##############
# Race table #
##############

func create_race_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + race_table + " (";
	query += "name text PRIMARY KEY"
	query += ");"
	
	return query
	
func insert_race():
	return "INSERT INTO " + race_table + "(name) VALUES(?);"
	
func select_race():
	return "SELECT * FROM " + race_table + " WHERE name = ?;"
	
#########################
# Character class table #
#########################

func create_character_class_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + class_table + " ("
	query += "name text PRIMARY KEY,"
	query += "race_fk text NOT NULL,"
	query += "FOREIGN KEY(race_fk) REFERENCES " + race_table + "(name)"
	query += ");"
	
	return query
	
func insert_character_class():
	return "INSERT INTO " + class_table + "(name, race_fk) VALUES(?,?);"
	
func select_character_class():
	return "SELECT * FROM " + class_table + " WHERE name = ?;"
	
#############
# Map table #
#############

func create_map_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + map_table + " ("
	query += "name text PRIMARY KEY"
	query += ");"
	
	return query
	
func insert_map():
	return "INSERT INTO " + map_table + "(name) VALUES(?);"
	
func select_map():
	return "SELECT * FROM " + map_table + " WHERE name = ?;"
	
##############
# Item table #
##############

func create_item_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + item_table + " ("
	query += "item_id integer PRIMARY KEY,"
	query += "name text NOT NULL,"
	query += "item_type_fk text NOT NULL,"
	query += "item_rarity_fk text NOT NULL,"
	query += "item_options text NOT NULL," #JSON string
	query += "FOREIGN KEY(item_type_fk) REFERENCES " + item_type_table + "(name),";
	query += "FOREIGN KEY(item_rarity_fk) REFERENCES " + item_rarity_table + "(name)";
	query += ");"
	
	return query
	
func select_item():
	return "SELECT * FROM " + item_table + " WHERE item_id = ?;"
	
func insert_item():
	var query = "INSERT INTO " + item_table + "("
	
	query += "name,"
	query += "item_type_fk,"
	query += "item_rarity_fk,"
	query += "item_options"
	
	query += ") VALUES(?,?,?,?);"
	
	return query
	
####################
# Item class table #
####################

func create_item_class_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + item_class_table + " ("
	query += "name text PRIMARY KEY"
	query += ");"
	
	return query
	
func insert_item_class():
	return "INSERT INTO " + item_class_table + "(name) VALUES(?);"
	
###################
# Item type table #
###################

func create_item_type_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + item_type_table + " ("
	query += "name text PRIMARY KEY,"
	query += "item_class_fk text NOT NULL,"
	query += "race_fk text NOT NULL,"
	query += "min_damage integer NOT NULL,"
	query += "max_damage integer NOT NULL,"
	query += "armour integer NOT NULL,"
	query += "inventory_width integer NOT NULL,"
	query += "inventory_height integer NOT NULL,"
	query += "FOREIGN KEY(item_class_fk) REFERENCES " + item_class_table + "(name),";
	query += "FOREIGN KEY(race_fk) REFERENCES " + race_table + "(name)";
	query += ");"
	
	return query
	
func insert_item_type():
	var query = "INSERT INTO " + item_type_table + "("
	
	query += "name,"
	query += "item_class_fk,"
	query += "race_fk,"
	query += "min_damage,"
	query += "max_damage,"
	query += "armour,"
	query += "inventory_width,"
	query += "inventory_height"
	
	query += ") VALUES(?,?,?,?,?);"
	
	return query
	
#####################
# Item rarity table #
#####################
	
func create_item_rarity_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + item_rarity_table + " ("
	query += "name text PRIMARY KEY"
	query += ");"
	
	return query
	
func insert_item_rarity():
	return "INSERT INTO " + item_rarity_table + "(name) VALUES(?);"
	
#####################
# Item option table #
#####################
	
func create_item_option_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + item_option_table + " ("
	query += "name text PRIMARY KEY,"
	query += "min_value integer NOT NULL,"
	query += "max_value integer NOT NULL"
	query += ");"
	
	return query
	
func insert_item_option():
	return "INSERT INTO " + item_option_table + "(name, min_value, max_value) VALUES(?,?,?);"
	
###################
# Inventory table #
###################

func create_inventory_table():
	var query
	
	query = "CREATE TABLE IF NOT EXISTS " + inventory_table + " ("
	query += "player_fk text NOT NULL,"
	query += "item_fk integer NOT NULL,"
	query += "inventory_x integer NOT NULL,"
	query += "inventory_y integer NOT NULL,"
	query += "FOREIGN KEY(player_fk) REFERENCES " + player_table + "(name),";
	query += "FOREIGN KEY(item_fk) REFERENCES " + item_table + "(item_id)";
	query += ");"
	
	return query
	
func select_inventory():
	return "SELECT * FROM " + inventory_table + " WHERE player_fk = ?;"
	
func insert_inventory_item():
	return "INSERT INTO " + inventory_table + "(player_fk, item_fk, inventory_x, inventory_y) VALUES(?,?,?,?);"