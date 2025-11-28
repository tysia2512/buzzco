class_name LevelPlay extends Node2D

@onready var enemy_tile_generator: EnemyTileGenerator = $EnemyTileGenerator
@onready var your_turn_label: Label = $YourTurnLabel
@onready var enemy_turn_label: Label = $EnemyTurnLabel
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var actions_left_label: Label = $ActionsLeftLabel
@onready var health_label: Label = $HealthLabel
@onready var grid: Grid = $CardMovementManager/Grid
@onready var deck: Deck = $CardMovementManager/DeckNHand/Deck
@onready var _global_effect_manager: GlobalEffectManager = $GlobalEffectManager
@onready var launch_attack_button: LaunchAttackButton = $LaunchAttackButton
@onready var _cancel_attack_button: Button = $CancelLaunchAttackButton
@onready var _deck_preview: DeckPreview = $DeckPreview

@onready var _debug_label: Label = $DebugLabel

signal level_cleared
signal game_over

var actions_left_in_turn: int

func _ready() -> void:
	GameState.player_turn_start.connect(start_player_turn)
	actions_left_in_turn = GameState.ACTIONS_PER_TURN
	launch_attack_button.grid = grid
	CardEventBus.select_card_from_deck.connect(_on_select_card_from_deck)
	ActionEventBus.perform_player_action.connect(_perform_action)

func _process(_delta):
	actions_left_label.text = "Actions left: " + str(actions_left_in_turn)
	_debug_label.text = "Global Effects: " + str(_global_effect_manager.get_global_effects())


func prepare_level(level: int):
	enemy_tile_generator.prepare_level(level)
	grid.set_up_new_level(level, enemy_tile_generator, enemy_manager)
	deck.load_deck()
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
	grid.process_start_player_turn()
	actions_left_in_turn = GameState.ACTIONS_PER_TURN

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

var _cards_selected_for_attack: Array = []

var _interrupted_stage_by_attack: GameState.TurnStage
func _on_launch_attack_button_launch_assault() -> void:
	_interrupted_stage_by_attack = GameState.turn_stage 
	_cancel_attack_button.visible = true
	GameState.turn_stage = GameState.TurnStage.SPECIFIC_INPUT
	GameState.specific_input = GameState.SpecificInput.LAUNCH_ATTACK_BEE_SELECT

func _on_cancel_launch_attack_button_pressed() -> void:
	_cancel_attack_button.visible = false
	_cards_selected_for_attack.clear()
	GameState.turn_stage = _interrupted_stage_by_attack

func _enemy_selected(enemy: Enemy) -> void:
	_perform_attack(enemy)

func _on_grid_card_selected_for_attack(card: TypedCard) -> void:
	if _cards_selected_for_attack.has(card):
		_cards_selected_for_attack.erase(card)
	else:
		_cards_selected_for_attack.append(card)

	if _cards_selected_for_attack.is_empty():
		GameState.specific_input = GameState.SpecificInput.LAUNCH_ATTACK_BEE_SELECT
	else:
		GameState.specific_input = GameState.SpecificInput.ENEMY_OR_BEE_SELECT

func _perform_attack(enemy: Enemy):
	var attack_points: int = 0
	for card in _cards_selected_for_attack:
		attack_points += card.card.get_attack_with_effects()

	for card in _cards_selected_for_attack:
		card.use_for_attack()
	_cards_selected_for_attack.clear()
	
	_attack_enemy(enemy, attack_points)
	_cancel_attack_button.visible = false
	GameState.turn_stage = _interrupted_stage_by_attack
	_perform_action()

func _attack_enemy(enemy: Enemy, attack_points: int) -> void:
	enemy.receive_damage(attack_points)

func _on_enemy_manager_deal_damage_to_player(dmg: int) -> void:
	dmg = _process_global_effects_on_damage_to_player(dmg)
	GameState.player_health = max(0, GameState.player_health - dmg)
	health_label.animate_health_loss(dmg)
	if GameState.player_health == 0:
		game_over.emit()

func _process_global_effects_on_damage_to_player(dmg: int) -> int:
	for effect in _global_effect_manager.get_global_effects():
		if effect.should_react_to_damage():
			dmg = effect.process_damage(dmg)
			return dmg
	return dmg

func _on_card_movement_manager_card_placed() -> void:
	deck.deal_cards(1)

func _on_enemy_manager_boulder_spawned(on_tile: GridTile) -> void:
	grid.spawn_boulder(on_tile)

func _on_grid_boulder_move_finished() -> void:
	GameState.turn_stage = GameState.TurnStage.ENEMY_MOVE
	start_enemy_turn()

func _on_grid_add_global_effect(effect: GlobalEffect) -> void:
	_global_effect_manager.add_global_effect(effect)

func _on_enemy_manager_all_enemies_dead() -> void:
	level_cleared.emit()

func _on_show_deck_preview_button_pressed() -> void:
	_deck_preview.load(deck, null)
	ActionEventBus.open_overlay.emit()
	_deck_preview.visible = true
	
var _interrupted_stage_by_deck_select
func _on_deck_preview_close_preview() -> void:
	if _interrupted_stage_by_deck_select != null:
		GameState.turn_stage = _interrupted_stage_by_deck_select
		_interrupted_stage_by_deck_select = null
	_deck_preview.visible = false
	ActionEventBus.close_overlay.emit()

func _on_select_card_from_deck(processor: CardSelectionProcessor) -> void:
	_interrupted_stage_by_deck_select = GameState.turn_stage
	GameState.turn_stage = GameState.TurnStage.SPECIFIC_INPUT
	GameState.specific_input = GameState.SpecificInput.DIALOG_CARD_SELECT
	_deck_preview.load(deck, processor)
	_deck_preview.visible = true
