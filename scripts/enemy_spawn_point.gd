class_name EnemySpawnPoint extends Node2D

signal enemy_selected

@onready var area_border: ReferenceRect = $AreaBorder
@onready var goon_hornet_enemy_scene: PackedScene = preload("res://scenes/goon_hornet_enemy.tscn")

@export var goon_hornet_enemy_count: int = 4

var _enemies: Array = []

func _ready():
	spawn_enemies()

func _input(event: InputEvent) -> void:
	if GameState.turn_stage != GameState.TurnStage.SPECIFIC_INPUT:
		return

	if GameState.specific_input != GameState.SpecificInput.ENEMY_SELECT:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if event.pressed:
			var enemy = check_for_enemy()
			await enemy.highlight()
			enemy_selected.emit(enemy)
	
func spawn_enemies():
	for i in range(0, goon_hornet_enemy_count):
		_spawn_enemy_invisible(goon_hornet_enemy_scene)
		
	_enemies.shuffle()
	_arrange_enemies()
	_set_enemies_visible()

func _spawn_enemy_invisible(scene: PackedScene):
	var enemy = scene.instantiate() as Enemy
	assert(enemy is Enemy)
	enemy.visible = false
	print("add child ", enemy)
	add_child(enemy)
	enemy.enemy.deal_damage.connect(deal_damage)
	_enemies.append(enemy)

func _arrange_enemies():
	if _enemies.is_empty():
		return
	if _enemies.size() == 1:
		_enemies[0].position.x = 0
		_enemies[0].position.y = 0

	var W = area_border.get_rect().size.x
	var sprite_width_total = _enemies.map(
		func(enemy): return (enemy as Enemy).get_texture_size().x).reduce(func(x, y): return x + y, 0)
	assert(W >= sprite_width_total)
	var gap = (W - sprite_width_total) / (_enemies.size() - 1)
	print("W: ", W, " sprite_width_total: ", sprite_width_total)
	var offset_x = W / 2
	var x = 0
	for enemy in _enemies:
		enemy.position.y = 0
		enemy.position.x = x + (enemy as Enemy).get_texture_size().x / 2 - offset_x
		print("Enemy position: ", enemy.position)
		x += (enemy as Enemy).get_texture_size().x + gap
	
	
func _set_enemies_visible():
	for enemy in _enemies:
		enemy.visible = true

func get_enemies() -> Array:
	return _enemies

func deal_damage(damage: int):
	get_parent().deal_damage.emit(damage)

func enemy_selected_for_attack(generic_enemy: GenericEnemy):
	var enemy

func check_for_enemy() -> Enemy:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 2 ** (GameState.EMEMY_COLLISION_LAYER - 1)
	var result = space_state.intersect_point(parameters, 1)
	if result.is_empty():
		return null
	var enemy = result[0].collider.get_parent()
	if !(enemy is Enemy):
		return null
	if !(enemy.get_parent() == self):
		return null
	return enemy
