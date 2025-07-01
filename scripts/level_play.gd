class_name LevelPlay extends Node2D

@onready var your_turn_label: Label = $YourTurnLabel
@onready var enemy_turn_label: Label = $EnemyTurnLabel
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var actions_left_label: Label = $ActionsLeftLabel
@onready var health_label: Label = $HealthLabel
@onready var grid: Grid = $CardMovementManager/Grid

signal level_cleared
signal player_moved

var actions_left_in_turn: int

func _ready() -> void:
	GameState.player_turn_start.connect(start_player_turn)
	actions_left_in_turn = GameState.ACTIONS_PER_TURN

func _process(delta):
	actions_left_label.text = "Actions left: " + str(actions_left_in_turn)

func prepare_level(level: int):
	GameState.turn_stage = GameState.TurnStage.PLAYER_MOVE

func _on_cheat_button_pressed() -> void:
	level_cleared.emit()

func start_enemy_turn():
	GameState.turn_stage = GameState.TurnStage.ENEMY_MOVE
	enemy_turn_label.visible = true
	await get_tree().create_timer(1.0).timeout
	enemy_turn_label.visible = false
	enemy_manager.perform_turn()
	
func start_player_turn():
	your_turn_label.visible = true
	await get_tree().create_timer(1.0).timeout
	your_turn_label.visible = false
	actions_left_in_turn = GameState.ACTIONS_PER_TURN

func _on_card_movement_manager_perform_player_action() -> void:
	_perform_action()

func _on_launch_attack_button_perform_player_action() -> void:
	_perform_action()

func _perform_action():
	actions_left_in_turn -= 1
	if actions_left_in_turn == 0:
		start_enemy_turn()


func _on_enemy_manager_enemy_turn_finished() -> void:
	actions_left_in_turn = GameState.ACTIONS_PER_TURN
	GameState.turn_stage = GameState.TurnStage.PLAYER_MOVE

func _on_enemy_manager_deal_damage(dmg: int) -> void:
	health_label.animate_health_loss(dmg)
	
func _on_launch_attack_button_launch_assault() -> void:
	var attack_points = grid.get_points()
	var enemy: Enemy
	if enemy_manager.get_enemies().size() == 1:
		enemy = enemy_manager.get_enemies()[0]
	else:
		print("TURNING THE TURN STAGE TO SPECIFIC_INPUT")
		GameState.turn_stage = GameState.TurnStage.SPECIFIC_INPUT
		GameState.specific_input = GameState.SpecificInput.ENEMY_SELECT
		enemy = await enemy_manager.enemy_spawn_point.enemy_selected
		# maybe not player?
		GameState.turn_stage = GameState.TurnStage.PLAYER_MOVE
		
	_attack_enemy(enemy, attack_points)
	grid.clear_cards()
	
	_perform_action()

func _attack_enemy(enemy: Enemy, attack_points: int) -> void:
	# TODO
	print("Attack enemy: ", enemy, " for: ", attack_points)
