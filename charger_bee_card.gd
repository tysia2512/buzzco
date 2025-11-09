class_name ChargerBeeCard extends TypedCard

const _charge_value = 3

func _on_card_player_turn_start() -> void:
	card.current_attack_points += _charge_value
