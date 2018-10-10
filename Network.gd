extends Node

var peer
var SERVER_PORT = 9292
var MAX_PLAYERS = 10

var character_info = {}
var maps = {}

func _ready():
	init()
	
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	
func init():
	DatabaseManager.init_database()
	init_maps()
	
func init_maps():
	maps.TestMap = { players = [] }
	
func _player_connected(id):
	print("A player has connected")
	
	var security_token = String(OS.get_ticks_msec() ^ randi()).hash()
	
	character_info[id] = {login_security_token = security_token}
	
	rpc_id(id, "network_init", security_token)
	
	#Check credentials
	#Associate credentials/connection to id
	#Load player information from the database
	#Add player to player list
	#Send information to all players in the same map about the new player
	#Send initialization info to the new player
	
	#var info = {
	#	id = id,
	#	map = "TestMap",
	#	position = Vector2(10, 10),
	#}
	
	#player_info[id] = info
	#maps[info.map].players.append(id)
	
	#rpc_id(id, "network_init", info)
	
func validate_credentials(id, security_token):
	return !character_info.has(id) || character_info[id].login_security_token != security_token
	
remote func login(id, player, password_hash, security_token):
	if validate_credentials(id, security_token):
		return
	
	var player_info = DatabaseManager.get_player(player)
	
	if (player_info.size() <= 0 ||
		player_info[0].password_hash != password_hash):
		rpc_id(id, "login_failure")
		return
	
	var player_characters = DatabaseManager.get_characters(player)
		
	rpc_id(id, "login_success", player_characters)
	
remote func register(id, login, password_hash, email, security_token):
	if validate_credentials(id, security_token):
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
	
remote func connect_character(id, security_token, character):
	if validate_credentials(id, security_token):
		return
	
	character_info[id]["character"] = character
	
	rpc_id(id, "character_connection_success")