extends Node2D

@onready var level_play_scene: PackedScene = preload("res://scenes/level_play.tscn")

@onready var intro_page: Node2D = $IntroPage
@onready var level_play: Node2D = $LevelPlay
@onready var next_level_page: NextLeveLPage = $NextLevelPage
@onready var game_over_page: Node2D = $GameOverPage
@onready var card_shop: Node2D = $CardShop

var level: int = 1

func _ready():
	intro_page.visible = true
	level_play.queue_free()
	next_level_page.visible = false
	game_over_page.visible = false

func _on_start_game_button_pressed() -> void:
	intro_page.visible = false
	instantiate_level(level)

func _on_level_play_level_cleared() -> void:
	level += 1
	level_play.queue_free()
	if level % 2 == 1:
		card_shop.load()
		card_shop.visible = true
	else:
		_show_next_level_page()

func _on_card_shop_card_shop_closed() -> void:
	card_shop.visible = false
	_show_next_level_page()

func _show_next_level_page() -> void:
	next_level_page.next_level_button.text = "Start level " + str(level)
	next_level_page.visible = true

func _on_next_level_button_pressed() -> void:
	instantiate_level(level)
	next_level_page.visible = false

func _on_level_play_game_over() -> void:
	level_play.queue_free()
	game_over_page.visible = true

func _on_new_game_button_pressed() -> void:
	level = 1
	instantiate_level(level)
	game_over_page.visible = false

func instantiate_level(lvl: int) -> void:
	level_play = level_play_scene.instantiate() as LevelPlay
	GameState.set_up_new_level(lvl)
	add_child(level_play)
	level_play.game_over.connect(_on_level_play_game_over)
	level_play.level_cleared.connect(_on_level_play_level_cleared)
	level_play.prepare_level(lvl)
