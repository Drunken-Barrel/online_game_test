extends Node

# constants
# Michael's ip is 114.75.22.30
const IP_ADDRESS: String = "LocalHost"
const PORT: int = 8067

# variables
# get the peer variable set to the right type
var peer: ENetMultiplayerPeer

func _ready() -> void:
	# if the ip is LocalHost, do not automatically start clients and servers, use buttons instead
	if IP_ADDRESS == "LocalHost": return
	
	# if ran by a dedicated server, become a server, otherwise become a client
	if OS.has_feature("dedicated_server"):
		start_server()
	else:
		start_client()

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS,PORT)
	multiplayer.multiplayer_peer = peer
