extends Node2D

signal player_turn_start

enum TurnStage {
	PLAYER_MOVE,
	ENEMY_MOVE
}

const ACTIONS_PER_TURN: int = 3

var turn_stage: TurnStage = TurnStage.PLAYER_MOVE

var player_health: int = 30

# TODO: move this to level_play
func is_player_turn() -> bool:
	return turn_stage == TurnStage.PLAYER_MOVE
