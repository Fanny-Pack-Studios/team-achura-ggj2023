@tool
extends RefCounted


var list := []
var path : set = set_path
var max_count := -1


func add(count: int) -> void:
	for i in count:
		var t := Transform3D()
		list.push_back(t)


func remove_at(count: int) -> void:
	count = int(max(count, 0)) # Prevent using a negative number
	var new_size = max(list.size() - count, 0)
	list.resize(new_size)


func resize(count: int) -> void:
	if max_count >= 0:
		count = int(min(count, max_count))

	var size = list.size()
	if count > size:
		add(count - size)
	else:
		remove_at(size - count)


func clear() -> void:
	list = []


func set_path(p: Path3D) -> void:
	path = p
