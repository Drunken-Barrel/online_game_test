extends Control

func _on_online_client_button_pressed() -> void:
	NetworkHandler.start_client("online")
	visible = false

func _on_local_server_button_pressed() -> void:
	NetworkHandler.start_server()
	visible = false

func _on_local_client_button_pressed() -> void:
	NetworkHandler.start_client("local")
	visible = false
