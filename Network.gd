extends Node

var peer
var SERVER_PORT = 9292
var MAX_PLAYERS = 10

var character_info = {}
var maps = {}

var PlayerCharacter = preload("res://Classes/Player/PlayerCharacter.gd")

func _ready():
	init()
	
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
func init():
	DatabaseManager.init_database()
	init_maps()
	
func init_maps():
	maps.TestMap = { players = [] }
	
func _player_connected(id):
	print("A player has connected")
	
	var security_token = String(OS.get_ticks_msec() ^ randi()).hash()
	
	character_info[id] = {
		login_security_token = security_token,
		player = ""
	}
	
	rpc_id(id, "network_init", security_token)
	
func _player_disconnected(id):
	if id > 1 && character_info.has(id):
		character_info.erase(id)
	
func validate_credentials(id, security_token):
	return !(!character_info.has(id) || character_info[id].login_security_token != security_token)
	
remote func login(id, player, password_hash, security_token):
	if !validate_credentials(id, security_token):
		return
	
	var player_info = DatabaseManager.get_player(player)
	
	if (player_info.size() <= 0 ||
		player_info[0].password_hash != password_hash):
		rpc_id(id, "login_failure")
		return
		
	if character_info[id]["player"] == player:
		rpc_id(id, "login_failure")
		return
		
	character_info[id]["player"] = player_info[0].login
		
	rpc_id(id, "login_success", DatabaseManager.get_characters(player))
	
remote func register(id, login, password_hash, email, security_token):
	if !validate_credentials(id, security_token):
		return
		
	if DatabaseManager.has_player(login):
		rpc_id(id, "registration_failure", "Username already taken")
		return
		
	if DatabaseManager.has_email(email):
		rpc_id(id, "registration_failure", "Email address already in use")
		return
		
	if DatabaseManager.insert_player(login, password_hash, email):
		rpc_id(id, "registration_success", "Registered successfully")
		return
	
	rpc_id(id, "registration_failure", "Registration failed")
	
remote func connect_character(id, security_token, character_name):
	if !validate_credentials(id, security_token):
		return
		
	var player = character_info[id]["player"]
	var error_message = Global.validate_character_connection(player, character_name)
	var character
	var map
	var character_position
	
	if error_message != null:
		rpc_id(id, "character_connection_failure", error_message)
		return
	
	character = PlayerCharacter.new()
	character.init_from_database(DatabaseManager.get_character(character_name))
	map = character.get_logout_map()
	character_position = {x = character.get_logout_x(), y = character.get_logout_y()}
	
	if !Map.validate_character_position(character):
		map = character.get_respawn_map()
		character_position = Map.get_respawn_position(map)
	
	character_info[id]["character"] = character
	
	rpc_id(id, "character_connection_success", map, character_position)
	
remote func create_character(id, security_token, serialized_character):
	if !validate_credentials(id, security_token):
		return
	
	var character = PlayerCharacter.new()
	character.deserialize(serialized_character)
	
	var player = character_info[id]["player"]
	var error_message = Global.validate_character_creation_info(player, character)
	
	if error_message != null:
		rpc_id(id, "character_creation_failure", error_message)
		return
		
	if !DatabaseManager.insert_player_character(player, character):
		rpc_id(id, "character_creation_failure", "An error has ocurred")
		return
		
	rpc_id(id, "character_creation_success", DatabaseManager.get_characters(player))
	
remote func delete_character(id, security_token, password_hash, character_name):
	if !validate_credentials(id, security_token):
		return
		
	var player = character_info[id]["player"]
	var player_info
	var db_character
	
	if player == null:
		rpc_id(id, "character_deletion_failure", "An error has ocurred")
		return
	
	player_info = DatabaseManager.get_player(player)
	
	if (player_info.size() <= 0 ||
		player_info[0].password_hash != password_hash):
		rpc_id(id, "character_deletion_failure", "An error has ocurred")
		return
		
	db_character = DatabaseManager.get_character(character_name)
	
	if (db_character.size() <= 0 ||
	    db_character[0].player_fk != player):
		rpc_id(id, "character_deletion_failure", "An error has ocurred")
		return
	
	DatabaseManager.delete_character(character_name)
	
	rpc_id(id, "character_deletion_success")