class_name AnimatedLabel extends Node2D

@onready var label: Label = $Label

var _is_moving: bool = false
var _velocity: Vector2 = Vector2(0.0, -0.1)

func set_text(txt: String):
	label.text = txt
	
func _process(delta: float):
	if _is_moving:
		position += _velocity * delta

#speed is in part of the screen per second
func animate(duration: float, velocity: Vector2 = Vector2(0.0, -0.1)):
	_velocity = Vector2(velocity.x * get_viewport_rect().size.x, velocity.y * get_viewport_rect().size.y)
	_is_moving = true
	await get_tree().create_timer(duration).timeout
	_is_moving = false
