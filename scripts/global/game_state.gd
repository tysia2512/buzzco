extends Node2D

enum TurnStage {
	ANIMATION,
	PLAYER_MOVE,
	ENEMY_MOVE
}

var turn_stage: TurnStage = TurnStage.PLAYER_MOVE

var player_health: int = 30
