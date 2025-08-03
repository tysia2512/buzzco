class_name LevelPlay extends Node2D

@onready var enemy_tile_generator: EnemyTileGenerator = $EnemyTileGenerator
@onready var your_turn_label: Label = $YourTurnLabel
@onready var enemy_turn_label: Label = $EnemyTurnLabel
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var actions_left_label: Label = $ActionsLeftLabel
@onready var health_label: Label = $HealthLabel
@onready var grid: Grid = $CardMovementManager/Grid
@onready var deck: Deck = $CardMovementManager/DeckNHand/Deck
@onready var launch_attack_button: LaunchAttackButton = $LaunchAttackButton

signal level_cleared
signal game_over

var actions_left_in_turn: int

func _ready() -> void:
	GameState.player_turn_start.connect(start_player_turn)
	actions_left_in_turn = GameState.ACTIONS_PER_TURN
	launch_attack_button.grid = grid

func _process(_delta):
	actions_left_label.text = "Actions left: " + str(actions_left_in_turn)

func prepare_level(level: int):
	GameState.set_up_new_level()
	enemy_tile_generator.prepare_level(level)
	grid.set_up_new_level(level, enemy_tile_generator, enemy_manager)
	deck.deal_cards(GameState.START_NUMBER_OF_CARDS)

func _on_cheat_button_pressed() -> void:
	level_cleared.emit()

func move_boulders():
	pass

func start_enemy_turn():
	GameState.turn_stage = GameState.TurnStage.ENEMY_MOVE
	enemy_turn_label.visible = true
	await get_tree().create_timer(1.0).timeout
	enemy_turn_label.visible = false
	enemy_manager.perform_turn()
	
func start_boulder_turn():
	GameState.turn_stage = GameState.TurnStage.BOULDER_MOVE
	grid.perform_boulder_move()

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
	_check_game_lost()
	if actions_left_in_turn == 0:
		start_boulder_turn()

func _check_game_lost():
	if grid.cards_on_board_count() == 0 and deck.get_cards_in_deck_count() == 0 and deck.get_cards_in_hand_count() == 0:
		game_over.emit()


func _on_enemy_manager_enemy_turn_finished() -> void:
	actions_left_in_turn = GameState.ACTIONS_PER_TURN
	GameState.turn_stage = GameState.TurnStage.PLAYER_MOVE

func _on_launch_attack_button_launch_assault() -> void:
	var attack_points = grid.get_points()
	var enemy: Enemy
	var interrupted_stage = GameState.turn_stage 
	if enemy_manager.get_enemies().size() == 1:
		enemy = enemy_manager.get_enemies()[0]
	else:
		GameState.turn_stage = GameState.TurnStage.SPECIFIC_INPUT
		GameState.specific_input = GameState.SpecificInput.ENEMY_SELECT
		enemy = await enemy_manager.enemy_selected
	
	GameState.turn_stage = interrupted_stage
	_attack_enemy(enemy, attack_points)
	grid.clear_cards()
	
	_perform_action()

func _attack_enemy(enemy: Enemy, attack_points: int) -> void:
	enemy.receive_damage(attack_points)


func _on_enemy_manager_deal_damage_to_player(dmg: int) -> void:
	GameState.player_health = max(0, GameState.player_health - dmg)
	health_label.animate_health_loss(dmg)
	if GameState.player_health == 0:
		game_over.emit()


func _on_card_movement_manager_card_placed() -> void:
	deck.deal_cards(1)

func _on_enemy_manager_boulder_spawned(on_tile: GridTile) -> void:
	grid.spawn_boulder(on_tile)


func _on_grid_boulder_move_finished() -> void:
	GameState.turn_stage = GameState.TurnStage.ENEMY_MOVE
	start_enemy_turn()


func _on_enemy_manager_all_enemies_dead() -> void:
	level_cleared.emit()
