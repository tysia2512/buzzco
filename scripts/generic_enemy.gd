# @tool
class_name GenericEnemy extends Node2D

signal deal_damage_to_player
signal enemy_died
signal boulder_spawned

var tile: Tile

var animated_label_scene: PackedScene = preload("res://scenes/animated_label.tscn")

@export var attack_points: int = 5
@export var max_health: int = 10
@export var attack_chance = 0.5
@export var boulder_drop_chance = 0.4
@export var texture: Texture2D
@export var polygon: PackedVector2Array

@onready var health_display: HealthDisplay = $HealthDisplay

@onready var sprite_with_collision: Node2D = $SpriteWithCollision
@onready var sprite: Sprite2D = $SpriteWithCollision/GridSprite2D
@onready var area: Area2D = $SpriteWithCollision/EnemyArea
@onready var collision_polygon: CollisionPolygon2D = $SpriteWithCollision/EnemyArea/CollisionPolygon2D
@onready var _texture_area: Polygon2D = $TextureArea

const SCALE_ON_HOVER_MULTIPLIER = 1.25
const SCALE_ON_ATTACK_MULTIPIER = 2.0
var _base_scale = Vector2.ONE

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

func _ready():
	sprite_with_collision.set_texture(texture)
	collision_polygon.polygon = polygon
	area.collision_layer = 2 ** (GameState.EMEMY_COLLISION_LAYER - 1)
	_health = max_health
	health_display.set_max_health(max_health)
	health_display.set_current_health(_health)
	_base_scale = scale

func _should_attack() -> bool:
	return Utils.rand_with_chance(attack_chance)

func attack():
	# TODO: this might collide, maybe better use process for this
	var scale_mult = SCALE_ON_ATTACK_MULTIPIER
	if _is_hovered:
		scale_mult = max(SCALE_ON_ATTACK_MULTIPIER, SCALE_ON_HOVER_MULTIPLIER)
	scale = _base_scale * scale_mult
	
	# TODO: keep the state of hover here
	if _should_attack():
		deal_damage_to_player.emit(attack_points)
		await _animate_damage("Attack: " + str(attack_points))
	else:
		await _animate_damage("Pass")
		
	scale = _base_scale

func _should_spawn_boulder() -> bool:
	return Utils.rand_with_chance(boulder_drop_chance)

func spawn_boulder():
	var scale_mult = SCALE_ON_ATTACK_MULTIPIER
	if _is_hovered:
		scale_mult = max(SCALE_ON_ATTACK_MULTIPIER, SCALE_ON_HOVER_MULTIPLIER)
	scale = _base_scale * scale_mult
	
	if _should_spawn_boulder():
		_spawn_boulder()
	
	scale = _base_scale

func _spawn_boulder():
	if tile and tile.get_bottom_neighbor():
		boulder_spawned.emit(tile.get_bottom_neighbor())
	
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

var _is_hovered = false

func _set_on_hover():
	_is_hovered = true
	scale *= SCALE_ON_HOVER_MULTIPLIER

func _set_stop_hover():
	_is_hovered = false
	scale = _base_scale

func _on_enemy_area_mouse_entered() -> void:
	_set_on_hover()

func _on_enemy_area_mouse_exited() -> void:
	_set_stop_hover()
