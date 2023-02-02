extends Control

var current_HP
var max_HP

func damaged(amount):
	current_HP = clamp(current_HP - amount, 0, max_HP)
	
func healed(amount):
	current_HP = clamp(current_HP + amount, 0, max_HP)

func set_max_hp(max):
	max_HP = max

func set_current_hp(current):
	current_HP = current
	
func _process(delta):
	$HPBarGreen.scale.x = current_HP/max_HP
	$Label.text = str(current_HP) + " / " + str(max_HP)
