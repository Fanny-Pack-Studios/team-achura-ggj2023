extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HTerrain/HTerrainDetailLayer.set_shader_parameter("u_capybara_pos", $Capybara.get_position())
	pass
