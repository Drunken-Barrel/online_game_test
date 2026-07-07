extends MultiplayerSpawner

#variables
@export var network_player: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(Player.despawn_player())

# id is a random number generated on connect
func spawn_player(id: int) -> void:
	# kick out anyone who isn't the server
	if !multiplayer.is_server(): return
	
	# spawn the player and name them after their id to track it
	var player: Node = network_player.instantiate()
	player.name = str(id)
	print(id)
	get_node(spawn_path).call_deferred("add_child",player)

#func despawn_player(id) -> void:
	## kick out anyone who isn't the server
	#if !multiplayer.is_server(): return
	#print(id)
	#var player = str(id)
	#remove_player.emit(player)
