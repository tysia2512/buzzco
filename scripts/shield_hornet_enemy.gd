# @tool
class_name ShieldHornetEnemy extends Enemy

@onready var shield_sprite: Sprite2D = $ShieldSprite

var _is_shielded = false
const shield_cooldown_max = 2
var shield_cooldown = shield_cooldown_max

func _ready():
	super._ready()
	shield_sprite.visible = false

func attack():
	if !_is_shielded && shield_cooldown == 0:
		await _shield_up()
	else:
		await super.attack()

	if !_is_shielded && shield_cooldown > 0:
		shield_cooldown -= 1

func _shield_up() -> void:
	await _enemy.animate_message("Shield up!")
	_is_shielded = true
	shield_sprite.visible = true

func receive_damage(pts: int) -> void:
	if _is_shielded:
		_is_shielded = false
		shield_sprite.visible = false
		shield_cooldown = shield_cooldown_max
	else:
		_enemy.receive_damage(pts)
