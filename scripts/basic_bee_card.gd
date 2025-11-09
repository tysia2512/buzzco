class_name BasicBeeCard extends TypedCard

const _attack_value = 1
const _name = "Basic Bee"
const _cost = 1

func _init():
	visible = false

func _ready():
	card.attack_value = _attack_value
	card.card_name = _name
	card.pollen_cost = _cost
	visible = true
	super._ready()
	
func _process(delta: float) -> void:
	card.current_attack_points = _attack_value
