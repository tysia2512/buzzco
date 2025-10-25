class_name ChargerBeeCard extends TypedCard

const _attack_value = 1
const _name = "Charger Bee"

func _init() -> void:
	visible = false

func _ready():
	card = $Card
	card.attack_value = _attack_value
	card.card_name = _name
	visible = true

func _on_card_player_turn_start() -> void:
	print("Increase the attack")
	card.current_attack_points += 1
