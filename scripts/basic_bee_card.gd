class_name BasicBeeCard extends TypedCard

const _attack_value = 1
const _name = "Basic Bee"

func _init():
	visible = false

func _ready():
	card = $Card
	card.attack_value = _attack_value
	card.card_name = _name
	visible = true
	
func _process(delta: float) -> void:
	card.current_attack_points = _attack_value
	
