extends Node2D

signal player_turn_start
signal card_staged_for_attack_changed
signal launch_attack_start
signal launch_attack_end

enum TurnStage {
	PLAYER_MOVE,
	BOULDER_MOVE,
	ENEMY_MOVE,
	SPECIFIC_INPUT
}

enum SpecificInput {
	ENEMY_OR_BEE_SELECT,
	LAUNCH_ATTACK_BEE_SELECT,
	DIALOG_CARD_SELECT
}

const DEBUG_MODE: bool = false
const POLLEN_ENABLED: bool = false

const EMEMY_COLLISION_LAYER: int = 3

const ACTIONS_PER_TURN: int = 3
const POLLEN_RECOVERED_ON_ASSAULT: int = 5
const PLAYER_START_HEALTH: int = 30
const START_POLLEN: int = 5
const START_NUMBER_OF_CARDS: int = 5

var turn_stage: TurnStage = TurnStage.PLAYER_MOVE:
	set(value):
		var old_value = turn_stage
		turn_stage = value
		if old_value == TurnStage.SPECIFIC_INPUT:
			return
		if value == TurnStage.PLAYER_MOVE:
			player_turn_start.emit()

var specific_input: SpecificInput:
	set(value):
		specific_input = value
		if value == SpecificInput.LAUNCH_ATTACK_BEE_SELECT:
			launch_attack_start.emit()

var player_health: int = 30

# TODO: move this to level_play
func is_player_turn() -> bool:
	return turn_stage == TurnStage.PLAYER_MOVE

#TODO: actions need to be removed because it doesn't make sense 
# to build a combon with pollen and launching the assault since it doesn't 
# make a difference if you launch the assault or not. Ideas:
# only the assault triggers the enemy attack
# the assault takes 3 actions

func set_up_new_level(level: int) -> void:
	if level == 1:
		DeckState.current_deck = DeckState.starter_deck.duplicate()
	turn_stage = GameState.TurnStage.PLAYER_MOVE
	player_health = GameState.PLAYER_START_HEALTH
	PollenManager.set_up_new_level()

var _cards_staged_for_attack: Array = []

func get_cards_staged_for_attack() -> Array:
	return _cards_staged_for_attack

func stage_card_for_attack(card: TypedCard) -> void:
	if !_cards_staged_for_attack.has(card):
		_cards_staged_for_attack.append(card)
	else:
		_cards_staged_for_attack.erase(card)
	
	card_staged_for_attack_changed.emit()

func clear_cards_staged_for_attack() -> void:
	_cards_staged_for_attack.clear()
	card_staged_for_attack_changed.emit()
