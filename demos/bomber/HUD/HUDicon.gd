extends TextureRect


func set_state(value):
	$AnimationTree.set("parameters/conditions/disable", !value)
	$AnimationTree.set("parameters/conditions/enable", value)
