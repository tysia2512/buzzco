extends Node2D

signal enemy_turn_start
signal player_turn_start

enum TurnStage {
	PLAYER_MOVE,
	ENEMY_MOVE
}

var turn_stage: TurnStage = TurnStage.PLAYER_MOVE

var player_health: int = 30

func is_player_turn() -> bool:
	return turn_stage == TurnStage.PLAYER_MOVE

# playing a card always ends a turn
func player_finished_turn():
	turn_stage = TurnStage.ENEMY_MOVE
	enemy_turn_start.emit()

func enemy_finished_turn():
	turn_stage = TurnStage.PLAYER_MOVE
	player_turn_start.emit()
