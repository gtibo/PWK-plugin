extends Control

onready var actions = {
	"can_punch": $PunchIcon,
	"can_throw_bomb": $BombIcon
}

func set_action(action_name, value):
	if !actions.has(action_name): return
	actions[action_name].set_state(value)
