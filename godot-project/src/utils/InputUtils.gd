class_name InputUtils
extends Object

static func get_mouse_position_on_same_plane(node: Node3D, a_viewport = null):
	var viewport = a_viewport if a_viewport else node.get_viewport()
	var mouse_position = viewport.get_mouse_position()
	
	var camera = viewport.get_camera_3d()
	
	var plane = Plane(Vector3.UP, node.global_position)
	
	return plane.intersects_ray(camera.project_ray_origin(mouse_position), camera.project_ray_normal(mouse_position))
