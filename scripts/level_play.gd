class_name LevelPlay extends Node2D

@onready var your_turn_label: Label = $YourTurnLabel
@onready var enemy_turn_label: Label = $EnemyTurnLabel
@onready var enemy_manager: EnemyManager = $EnemyManager

signal level_cleared
signal player_moved

func _ready() -> void:
	GameState.enemy_turn_start.connect(start_enemy_turn)
	GameState.player_turn_start.connect(start_player_turn)

func prepare_level(level: int):
	GameState.turn_stage = GameState.TurnStage.PLAYER_MOVE

func _on_cheat_button_pressed() -> void:
	level_cleared.emit()

func start_enemy_turn():
	enemy_turn_label.visible = true
	await get_tree().create_timer(1.0).timeout
	enemy_turn_label.visible = false
	enemy_manager.perform_turn()
	
func start_player_turn():
	your_turn_label.visible = true
	await get_tree().create_timer(1.0).timeout
	your_turn_label.visible = false
