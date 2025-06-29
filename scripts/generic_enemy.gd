class_name GenericEnemy extends Node2D

signal deal_damage

var animated_label_scene: PackedScene = preload("res://scenes/animated_label.tscn")

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

func should_attack() -> bool:
	if _attack_every_turns != null:
		_turns_until_next_attack -= 1
		if _turns_until_next_attack == 0:
			_turns_until_next_attack = _attack_every_turns
			return true
	else:
		var attacks_this_turn = rng.rand_weighted([_attack_chance, 1.0 - _attack_chance])
		if attacks_this_turn == 0:
			return true
	return false
			
func attack():
	if should_attack():
		deal_damage.emit(attack_points)
		await _animate_damage("Attack: " + str(attack_points))
	else:
		await _animate_damage("Pass")

func _animate_damage(msg: String):
	var label: AnimatedLabel = animated_label_scene.instantiate() as AnimatedLabel
	label.visible = false
	add_child(label)
	label.set_text(msg)
	label.visible = true
	await label.animate(1.0)
	label.queue_free()
	
