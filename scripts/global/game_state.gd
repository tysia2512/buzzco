extends Node2D

signal player_turn_start


enum TurnStage {
	PLAYER_MOVE,
	BOULDER_MOVE,
	ENEMY_MOVE,
	SPECIFIC_INPUT
}

enum SpecificInput {
	ENEMY_SELECT,
	GRID_CARD_SELECT
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
		turn_stage = value
		if value == TurnStage.PLAYER_MOVE:
			player_turn_start.emit()

var specific_input: SpecificInput
var enemy_select_for_attack: int

var player_health: int = 30

# TODO: move this to level_play
func is_player_turn() -> bool:
	return turn_stage == TurnStage.PLAYER_MOVE

#TODO: actions need to be removed because it doesn't make sense 
# to build a combon with pollen and launching the assault since it doesn't 
# make a difference if you launch the assault or not. Ideas:
# only the assault triggers the enemy attack
# the assault takes 3 actions

func set_up_new_level():
	turn_stage = GameState.TurnStage.PLAYER_MOVE
	player_health = GameState.PLAYER_START_HEALTH
	PollenManager.set_up_new_level()
