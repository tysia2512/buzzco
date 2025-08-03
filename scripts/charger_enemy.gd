class_name ChargerEnemy extends Enemy

var charge_chance = 0.5
const attack_base: int = 4

func _ready():
	_enemy = $GenericEnemy

func attack():
	if Utils.rand_with_chance(charge_chance):
		await _charge()
	else:
		await super.attack()
		_enemy.attack_points = attack_base
	
func _charge() -> void:
	var diff = _enemy.attack_points
	_enemy.attack_points *= 1.5
	diff = _enemy.attack_points - diff
	await _enemy.animate_message("Charging: +%d" % diff)
	
