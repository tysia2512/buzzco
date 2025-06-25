class_name GenericEnemy extends Node2D

signal deal_damage

@export var health: int = 10
@export var attack_points: int = 5

var _attack_every_turns = null
var _attack_chance = null

var _turns_until_next_attack = null

var rng = RandomNumberGenerator.new()

func set_attack_every_turns(turns: int):
	_attack_every_turns = turns
	_turns_until_next_attack = _attack_every_turns
	_attack_chance = null
	
func set_attack_chance(chance: float) -> void:
	_attack_chance = chance
	_attack_every_turns = null

func after_player_moved():
	if _attack_every_turns != null:
		_turns_until_next_attack -= 1
		if _turns_until_next_attack == 0:
			_turns_until_next_attack = _attack_every_turns
			attack()
	else:
		var attacks_this_turn = rng.rand_weighted([_attack_chance, 1.0 - _attack_chance])
		if attacks_this_turn == 0:
			attack()
			
func attack():
	deal_damage.emit(attack_points)
	
	
