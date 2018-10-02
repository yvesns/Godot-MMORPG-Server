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
	
remote func login(id, player, password_hash, security_token):
	if (!character_info.has(id) ||
		character_info[id].login_security_token != security_token):
		return
	
	var player_info = DatabaseManager.get_player(player)
	var player_characters = DatabaseManager.get_characters(player)
	
	if (!player_info || 
		player_info.password_hash != password_hash ||
		!player_characters):
		rpc_id(id, "login_failure")
		return
		
	rpc_id(id, "login_success", user_characters)
	
remote func register(login, password, email):
	if DatabaseManager.has_player(login):
		return [false, "Username already taken"]
		
	if DatabaseManager.has_email(email):
		return [false, "Email address already in use"]
		
	if DatabaseManager.insert_player(login, str(password.hash()), email):
		return [true, "Registered successfully"]
	
	return [false, "Registration failed"]