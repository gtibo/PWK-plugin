extends PathFollow2D
export(NodePath) onready var path_tween = get_node(path_tween) as Tween


func _ready():
	launch_tween()
func launch_tween():
	path_tween.interpolate_property(self, "unit_offset", 0 ,1, 20)
	path_tween.start()


func _on_Tween_tween_all_completed():
	launch_tween()
