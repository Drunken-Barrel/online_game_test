extends Control

func _ready() -> void:
	if NetworkHandler.IP_ADDRESS != "LocalHost":
		visible = false

func _on_server_button_pressed() -> void:
	NetworkHandler.start_server()
	visible = false

func _on_client_button_pressed() -> void:
	NetworkHandler.start_client()
	visible = false
