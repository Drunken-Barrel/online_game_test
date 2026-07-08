extends Node

# constants
# Michael's ip is 114.75.22.30
const IP_ADDRESS: String = "114.75.22.30"
const LOCAL_HOST: String = "LocalHost"
const PORT: int = 8067

# variables
# get the peer variable set to the right type
var peer: ENetMultiplayerPeer

func _ready() -> void:
	# if ran by a dedicated server, become a server
	if OS.has_feature("dedicated_server"):
		start_server()

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func start_client(type) -> void:
	peer = ENetMultiplayerPeer.new()
	if type == "online":
		peer.create_client(IP_ADDRESS,PORT)
	else:
		peer.create_client(LOCAL_HOST,PORT)
	multiplayer.multiplayer_peer = peer
