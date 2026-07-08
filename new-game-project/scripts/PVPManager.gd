extends Node

# signals
signal output_damage_signal

func output_damage(user_id: String,damage: int) -> void:
	output_damage_signal.emit(user_id,damage)
