extends State

export(NodePath) onready var blur_node = get_node(blur_node)
export(NodePath) onready var game_selection = get_node(game_selection)
export(NodePath) onready var game_info = get_node(game_info)
export(NodePath) onready var bg = get_node(bg)

export(Resource) var main_sfx_manager

func handle_input(_event):
	if owner.in_bluring: return
	if Input.is_action_pressed("0_b_button"):
		state_machine.transition_to("Home")
		return
	if Input.is_action_pressed("0_a_button"):
		owner.current_game_info = game_selection.selection_data()
		game_info.setup(owner.current_game_info)
		var scene_path = owner.current_game_info.main_scene_path
		bg.hide()
		state_machine.transition_to("InGame", {"scene":scene_path})
	if Input.is_action_pressed("0_left_button"):
		game_selection.switch(-1)
		main_sfx_manager.play("click")
		return
	if Input.is_action_pressed("0_right_button"):
		game_selection.switch(1)
		main_sfx_manager.play("click")
		return

			
func enter(_msg := {}):
	owner.set_actions([
		["a","Launch demo"], 
		["b","Return to home"],
		["arrows","Switch demo"]
		],
		Color.white)
	owner.set_blur(true)
	game_selection.show()

func exit():
	owner.set_blur(false)
	game_selection.hide()
