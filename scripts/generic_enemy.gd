# @tool
class_name GenericEnemy extends Node2D

signal deal_damage
signal enemy_died

var animated_label_scene: PackedScene = preload("res://scenes/animated_label.tscn")

@export var attack_points: int = 5
@export var max_health: int = 10
@export var attack_chance = 0.5
@export var texture: Texture2D
@export var polygon: PackedVector2Array

@onready var health_display: HealthDisplay = $HealthDisplay

@onready var sprite_with_collision: Node2D = $SpriteWithCollision
@onready var sprite: Sprite2D = $SpriteWithCollision/Sprite2D
@onready var area: Area2D = $SpriteWithCollision/EnemyArea
@onready var collision_polygon: CollisionPolygon2D = $SpriteWithCollision/EnemyArea/CollisionPolygon2D
@onready var _texture_area: Polygon2D = $TextureArea

var _health: int = 10

var rng = RandomNumberGenerator.new()

func receive_damage(attack_points: int) -> void:
	var m = sprite.modulate
	sprite.modulate = Color.RED
	_health = max(0, _health - attack_points)
	health_display.set_current_health(_health)
	await get_tree().create_timer(0.5).timeout
	if _health == 0:
		enemy_died.emit(get_parent())
	else:
		sprite.modulate = m

func get_area_size() -> Vector2:
	var max_x = _texture_area.polygon[0].x
	var min_x = _texture_area.polygon[0].x
	var max_y = _texture_area.polygon[0].y
	var min_y = _texture_area.polygon[0].y
	for vertex in _texture_area.polygon:
		max_x = max(max_x, vertex.x)
		min_x = min(min_x, vertex.x)
		max_y = max(max_y, vertex.y)
		min_y = min(min_y, vertex.y)

	var w = max_x - min_x
	var h = max_y - min_y

	return Vector2(w, h)

func _get_texture_scale() -> Vector2:
	var area_size = get_area_size()
	var scale_x = area_size.x / texture.get_width()
	var scale_y = area_size.y / texture.get_height()
	var s = min(scale_x, scale_y)
	return Vector2(s, s)

func _ready():
	sprite_with_collision.scale = _get_texture_scale()
	sprite.texture = texture
	collision_polygon.polygon = polygon
	area.collision_layer = 2 ** (GameState.EMEMY_COLLISION_LAYER - 1)
	_health = max_health
	health_display.set_max_health(max_health)
	health_display.set_current_health(_health)

func should_attack() -> bool:
	var attacks_this_turn = rng.rand_weighted([attack_chance, 1.0 - attack_chance])
	if attacks_this_turn == 0:
		return true
	return false
			
func attack():
	if should_attack():
		deal_damage.emit(attack_points)
		await _animate_damage("Attack: " + str(attack_points))
	else:
		await _animate_damage("Pass")

func _animate_damage(msg: String):
	var label: AnimatedLabel = animated_label_scene.instantiate() as AnimatedLabel
	label.visible = false
	add_child(label)
	label.set_text(msg)
	label.visible = true
	await label.animate(1.0)
	label.queue_free()

func highlight():
	_highlight(Color.WHITE)

func _highlight(color: Color) -> void:
	var m = sprite.modulate
	sprite.modulate = color
	await get_tree().create_timer(0.5).timeout
	sprite.modulate = m
