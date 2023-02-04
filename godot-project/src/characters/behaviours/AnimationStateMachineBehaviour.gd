class_name AnimationStateMachineBehaviour
extends Node

@onready @export var animation_tree = $"../AnimationTree"

signal state_changed

func current_state():
	return animation_state_machine().get_current_node()
	
func change_state(new_state: StringName, on_state_entered: Callable = func (state): pass, force: bool = false):
	if current_state() != new_state || force:
		on_state_entered.call(new_state)
		if force:
			animation_state_machine().start(new_state, true)
		else:
			animation_state_machine().travel(new_state)
		emit_signal("state_changed", new_state)
		
	
func animation_state_machine() -> AnimationNodeStateMachinePlayback:
	return animation_tree["parameters/playback"]
