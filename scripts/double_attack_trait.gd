class_name DoubleAttackTrait extends Trait

@export var attacks = 2

func process_attack():
	attacks -= 1
	if attacks == 0:
		is_active = false

func should_stay_after_attack():
	return attacks > 0
