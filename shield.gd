class_name Shield extends GlobalEffect

func should_react_to_damage() -> bool:
    return true

func process_damage(damage: int) -> int:
    return 0