class_name GoonHornetEnemy extends Enemy

func ready():
	enemy = $GenericEnemy
	enemy.set_attack_chance(0.3)
	
