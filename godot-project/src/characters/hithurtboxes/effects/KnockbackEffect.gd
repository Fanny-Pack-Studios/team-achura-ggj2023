class_name KnockbackEffect
extends AttackEffect

@export var strength: float = 5

func apply_on_character(char: Character):
	char.knockback(self.global_position, strength)
	
