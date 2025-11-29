class_name ChargerEnemy extends Enemy

@export var charge_chance = 0.5

var _attack_base

func _ready():
	_attack_base = _enemy.attack_points
	super._ready()

func attack():
	if Utils.rand_with_chance(charge_chance):
		await _charge()
	else:
		await super.attack()
		_enemy.attack_points = _attack_base
	
func _charge() -> void:
	var diff = _enemy.attack_points
	_enemy.attack_points *= 1.5
	diff = _enemy.attack_points - diff
	await _enemy.animate_message("Charging: +%d" % diff)
	
