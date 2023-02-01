class_name AnimationStateMachineBehaviour
extends Node

@export var animation_tree = $"../AnimationTree"

func current_state():
	return animation_state_machine().get_current_node()
	
func change_state(new_state: StringName, on_state_entered: Callable = func (state): pass ):
	if current_state() != new_state:
		on_state_entered.call(new_state)
		animation_state_machine().travel(new_state)
	
func animation_state_machine() -> AnimationNodeStateMachinePlayback:
	return animation_tree["parameters/playback"]
