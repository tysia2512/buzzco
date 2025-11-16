#@tool
class_name CardDisplay extends Node2D

signal mouse_entered
signal mouse_exited
signal card_clicked

@export var texture: Texture2D:
	set(value):
		texture = value
		if _image_sprite:
			_image_sprite.texture = value
			_resize_texture()
			
@export var card_name: String:
	set(value):
		card_name = value
		if _image_sprite:
			$Name.text = value
			
@export var attack: int = 10:
	set(value):
		attack = value
		if _image_sprite:
			$AttackPts.text = str(value)
@export var description: String = "This is a card. It can be played and placed on the board.":
	set(value):
		description = value
		if _image_sprite:
			$Description.text = value

@export var card: TypedCard = null:
	set(value):
		card = value
		if _collision_polygon:
			_collision_polygon.card = value

@export var enable_collision: bool = true:
	set(value):
		enable_collision = value
		if _collision_polygon:
			_collision_polygon.disabled = !value

@onready var _image_sprite: Sprite2D = $ImageSprite
@onready var _card_template_sprite: Sprite2D = $CardTemplateSprite
@onready var _image_polygon: Polygon2D = $CardTemplateSprite/Polygon2D
@onready var _collision_polygon: CardCollisionPolygon = $Area2D/CollisionPolygon2D
@onready var trait_containters: Node2D = $TraitContainers

func _ready():
	_image_sprite.texture = texture
	if _image_sprite.texture:
		_resize_texture()
	$Name.text = card_name
	$Description.text = description
	$AttackPts.text = str(attack)
	_collision_polygon.card = card
	_collision_polygon.disabled = !enable_collision
	
func _resize_texture():
	if !_image_polygon or _image_polygon.polygon.is_empty():
		return

	Utils.resize_sprite_to_polygon(_image_sprite, _image_polygon)

func get_texture_size():
	return _card_template_sprite.texture.get_size() * _card_template_sprite.scale * scale

func _on_area_2d_mouse_entered() -> void:
	mouse_entered.emit()
func _on_area_2d_mouse_exited() -> void:
	mouse_exited.emit()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		card_clicked.emit()

func add_trait(t: Trait):
	var sprite = Sprite2D.new()
	sprite.texture = t.texture
	var found_rec = false
	for rec in trait_containters.get_children():
		assert(rec is Polygon2D)
		if rec.get_child_count() == 0:
			found_rec = true
			rec.add_child(sprite)
			Utils.resize_sprite_to_polygon(sprite, rec)
			break
	assert(found_rec, "Too many traits")
