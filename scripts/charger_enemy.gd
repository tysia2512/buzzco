class_name ChargerEnemy extends Enemy

var charge_chance = 0.5
const attack_base = 4

func _ready():
	_enemy = $GenericEnemy

func attack():
	if Utils.rand_with_chance(charge_chance):
		_charge()
	else:
		super.attack()
		_enemy.attack_points = attack_base
	
func _charge() -> void:
	_enemy.attack_points *= 1.5
