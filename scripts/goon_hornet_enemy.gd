class_name GoonHornetEnemy extends Enemy

func _ready():
	enemy = $GenericEnemy
	enemy.set_attack_chance(0.3)
	enemy.set_area($Area2D)
	sprite = $Sprite2D
