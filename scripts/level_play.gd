class_name LevelPlay extends Node2D

@onready var your_turn_label: Label = $YourTurnLabel
@onready var enemy_turn_label: Label = $EnemyTurnLabel
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var actions_left_label: Label = $ActionsLeftLabel
@onready var health_label: Label = $HealthLabel

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
	
