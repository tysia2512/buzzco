class_name GoonHornetEnemy extends Enemy

func _ready():
	enemy = $GenericEnemy
	print("Has enemy with size: ", enemy.get_area_size())
