extends CanvasLayer

@onready var draw = $DebugDraw3D

func _input(event):
	if event.is_action_pressed("toggle_debug"):
		for n in get_children():
			n.visible = not n.visible
			
func add_vector(object, property, color = Color(0,1,0, 0.8), a_scale = 1, width = 4):
	draw.add_vector(object, property, a_scale, width, color)
