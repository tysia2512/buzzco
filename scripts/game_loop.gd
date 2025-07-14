extends Node2D

@onready var intro_page: Node2D = $IntroPage
@onready var level_play: Node2D = $LevelPlay
@onready var next_level_page: NextLeveLPage = $NextLevelPage
@onready var game_over_page: Node2D = $GameOverPage

var level: int = 1

func _ready():
	intro_page.visible = true
	level_play.visible = false
	next_level_page.visible = false
	game_over_page.visible = false

func _on_start_game_button_pressed() -> void:
	level_play.prepare_level(level)
	intro_page.visible = false
	level_play.visible = true

func _on_level_play_level_cleared() -> void:
	level += 1
	level_play.visible = false
	next_level_page.next_level_button.text = "Start level " + str(level)
	next_level_page.visible = true

func _on_next_level_button_pressed() -> void:
	level_play.prepare_level(level)
	next_level_page.visible = false
	level_play.visible = true

func _on_button_pressed() -> void:
	level = 1
	level_play.prepare_level(level)
	game_over_page.visible = false
	level_play.visible = true

func _on_level_play_game_over() -> void:
	level_play.visible = false
	game_over_page.visible = true
