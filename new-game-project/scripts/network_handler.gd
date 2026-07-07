extends Node

# 114.75.22.30
const IP_ADDRESS: String = "114.75.22.30"
const PORT: int = 8067

var peer: ENetMultiplayerPeer

func _ready() -> void:
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
