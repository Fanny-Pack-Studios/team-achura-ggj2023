extends Control

class Vector:
	var object  # The node to follow
	var property  # The property to draw
	var scale  # Scale factor
	var width  # Line width
	var color  # Draw color

	func _init(_object,_property,_scale,_width,_color):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color

	func draw(node: Control, camera):
		var start = camera.unproject_position(object.global_transform.origin)
		var end = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		node.draw_line(start, end, color, width)
		node.draw_circle(end, width * 2, color)
		
func _process(_delta):
	if not visible:
		return
	queue_redraw()

func _draw():
	var camera = get_viewport().get_camera_3d()
	for vector in vectors:
		vector.draw(self, camera)

func add_vector(object, property, a_scale, width, color):
	vectors.append(Vector.new(object, property, a_scale, width, color))

var vectors = []  # Array to hold all registered values.
