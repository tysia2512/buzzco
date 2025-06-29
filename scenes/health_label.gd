class_name HealthLabel extends Label

@onready var animated_label: AnimatedLabel = $AnimatedLabel

var _animated_label_initial_position: Vector2

func _ready():
	_animated_label_initial_position = animated_label.position

func _process(delta: float):
	text = str(GameState.player_health)
	
func animate_health_loss(dmg: int):
	GameState.player_health -= dmg
	animated_label.set_text("-" + str(dmg))
	animated_label.visible = true
	await animated_label.animate(1.0)
	animated_label.visible = false
	animated_label.position = _animated_label_initial_position
	
