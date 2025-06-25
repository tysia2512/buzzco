class_name GoonHornetEnemy extends Enemy

func _ready():
	enemy = $GenericEnemy
	enemy.set_attack_chance(0.3)
	sprite = $Sprite2D
	
