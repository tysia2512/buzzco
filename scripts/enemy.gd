class_name Enemy extends Node2D

signal deal_damage_to_player
signal enemy_died
signal boulder_spawned

@onready var _input_sprite: Sprite2D = $Sprite2D
@onready var _input_polygon: Polygon2D = $Polygon2D

var _enemy: GenericEnemy

func _init():
	update_configuration_warnings()

func _ready():
	_enemy = _find_generic_enemy_in_children()
	_connect_signals()
	_enemy.texture = _input_sprite.texture
	_enemy.polygon = _input_polygon.polygon
	assert(_enemy != null, "Enemy node must have a GenericEnemy as a child node")

func _get_configuration_warning() -> String:
	if not _find_generic_enemy_in_children():
		return "Must have a GenericEnemy as a child node"
	if not _input_polygon or _input_polygon.polygon.size() < 3:
		return "Polygon is not set"
	if not _input_sprite or _input_sprite.texture == null:
		return "Sprite2D is not set or does not have a texture"

	return ""

func _find_generic_enemy_in_children() -> GenericEnemy:
	for child in get_children():
		if child is GenericEnemy:
			return child
	return null

		
var tile: EnemyTile

func attack():
	await _enemy.attack()

func spawn_boulder():
	await _enemy.spawn_boulder()

func highlight() -> void:
	await _enemy.highlight()

func set_tile(t: EnemyTile):
	_enemy.tile = t

func get_tile() -> EnemyTile:
	return _enemy.tile

#Remove?
func _connect_signals():
	_enemy.deal_damage_to_player.connect(func(pts): deal_damage_to_player.emit(pts))
	_enemy.enemy_died.connect(func(): enemy_died.emit(self))
	_enemy.boulder_spawned.connect(func(t): boulder_spawned.emit(t))

func receive_damage(pts: int) -> void:
	_enemy.receive_damage(pts)

var move_tile_tween: Tween
func move_animation(diff: Vector2) -> void:
	move_tile_tween = create_tween()
	move_tile_tween.tween_property(self, "position", position + diff, 0.3)

func can_be_selected_for_attack() -> bool:
	if GameState.turn_stage != GameState.TurnStage.SPECIFIC_INPUT:
		return false

	if GameState.specific_input != GameState.SpecificInput.ENEMY_OR_BEE_SELECT and GameState.specific_input != GameState.SpecificInput.LAUNCH_ATTACK_BEE_SELECT:
		return false

	var cards_below = _enemy.tile.get_tiles_below().map(
		func(t): return t.get_card()
		).filter(
		func(c): return c != null
		).filter(
		func(c): return GameState.get_cards_staged_for_attack().has(c)
		)

	return !cards_below.is_empty()
