extends Control

onready var actions = {
	"can_punch": $PunchIcon,
	"can_throw_bomb": $BombIcon
}

func set_ko():
	modulate.a = 0.5
	$HeadSprite.set_state("sleep")

func set_theme(t):
	$HeadSprite.set_theme(t)
	$HeadSprite.set_state("smile")

func set_action(action_name, value):
	if !actions.has(action_name): return
	actions[action_name].set_state(value)
