extends Node
class_name JoyMap, "res://addons/PWK/icones/JoyMap_icon.svg"

enum AxisKeys { 
	ArrowLeft = KEY_LEFT, 
	ArrowRight = KEY_RIGHT, 
	ArrowUp = KEY_UP, 
	ArrowDown = KEY_DOWN,
	A = KEY_A,
	B = KEY_B,
	X = KEY_X,
	Y = KEY_Y,
	SELECT = KEY_S,
	}

export(String, "keyboard", "joypad") var type = "joypad"
# For JoyPad
export (int,0,3) var controller_index
# For keyboard
export(AxisKeys) var left = AxisKeys.ArrowLeft
export(AxisKeys) var right = AxisKeys.ArrowRight
export(AxisKeys) var up = AxisKeys.ArrowUp
export(AxisKeys) var down = AxisKeys.ArrowDown
export(AxisKeys) var a_button = AxisKeys.A
export(AxisKeys) var b_button = AxisKeys.B
export(AxisKeys) var y_button = AxisKeys.Y
export(AxisKeys) var x_button = AxisKeys.X
export(AxisKeys) var select_button = AxisKeys.SELECT


func _ready():
	call("set_"+type)

func set_keyboard():
	var btn = {"a":a_button,"b":b_button,"y":y_button,"x":x_button,"select":select_button, "left": left, "right": right, "up": up, "down": down}
	for k in btn:
		var action_name = str(controller_index)+"_"+ k +"_button"
		var env = InputEventKey.new()
		env.scancode = btn[k]
		InputMap.add_action(action_name)
		InputMap.action_add_event(action_name, env)
		
func set_joypad():
	var btn = {
		"a":JOY_DS_A,
		"b":JOY_DS_B,
		"x":JOY_DS_X,
		"y":JOY_DS_Y,
		"left": JOY_DPAD_LEFT,
		"right": JOY_DPAD_RIGHT, 
		"up": JOY_DPAD_UP,
		"down": JOY_DPAD_DOWN,
		"l": JOY_L,
		"select": JOY_SELECT
		}
	var sticks = {"left-right": JOY_AXIS_0, "up-down": JOY_AXIS_1}
	
	for k in btn:
		var action_name = str(controller_index)+"_"+ k +"_button"
		var env = InputEventJoypadButton.new()
		env.button_index = btn[k]
		env.device = controller_index
		InputMap.add_action(action_name)
		InputMap.action_add_event(action_name, env)

	for s in sticks:
		var axis = sticks[s]
		var axis_value = [-1, 1]
		var actions_names = s.split("-")
		for i in range(actions_names.size()):
			var env = InputEventJoypadMotion.new()
			env.axis = axis
			env.axis_value = axis_value[i]
			env.device = controller_index
			InputMap.action_add_event(str(controller_index)+"_"+ actions_names[i] +"_button", env)
