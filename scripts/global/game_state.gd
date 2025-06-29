extends Node2D

signal player_turn_start

enum TurnStage {
	PLAYER_MOVE,
	ENEMY_MOVE
}

const ACTIONS_PER_TURN: int = 3
const POLLEN_RECOVERED_ON_ASSAULT: int = 5

var turn_stage: TurnStage = TurnStage.PLAYER_MOVE

var player_health: int = 30

# TODO: move this to level_play
func is_player_turn() -> bool:
	return turn_stage == TurnStage.PLAYER_MOVE

#TODO: actions need to be removed because it doesn't make sense 
# to build a combon with pollen and launching the assault since it doesn't 
# make a difference if you launch the assault or not. Ideas:
# only the assault triggers the enemy attack
# the assault takes 3 actions
