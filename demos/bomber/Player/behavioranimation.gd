extends AnimationTree

	
func _on_StateMachine_transitioned(state_name):
	if state_name == "Run":
		self["parameters/conditions/run"] = true
		self["parameters/conditions/idle"] = false
		self["parameters/conditions/jump"] = false
		self["parameters/conditions/slide"] = false
		
		
	if state_name == "Idle":
		self["parameters/conditions/run"] = false
		self["parameters/conditions/idle"] = true
		self["parameters/conditions/jump"] = false
		self["parameters/conditions/slide"] = false
		
		
	if state_name == "Air":
		self["parameters/conditions/jump"] = true
		self["parameters/conditions/idle"] = false
		self["parameters/conditions/run"] = false
		self["parameters/conditions/slide"] = false
		
	
	if state_name == "Slide":
		self["parameters/conditions/slide"] = true
		self["parameters/conditions/jump"] = false
		self["parameters/conditions/idle"] = false
		self["parameters/conditions/run"] = false
		
func _on_Player_changeDirection(direction):
	if direction > 0:
		get_node("../TextureRect").flip_h = true
	else:
		get_node("../TextureRect").flip_h = false

func _on_Player_punch():
	var state_machine = self["parameters/playback"]
	state_machine.travel("Punch")
