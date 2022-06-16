extends Tween

export(NodePath) onready var start_position = get_node(start_position)
export(NodePath) onready var end_position = get_node(end_position)
export(NodePath) onready var target = get_node(target) as Area2D

export(Resource) var RuleManager

func _ready():
	interpolate_property(target, "position", start_position.position, end_position.position, 120)
	start()
	RuleManager.connect("victory", self, "on_victory")

func on_victory(_player):
	stop(target, "position")
	target.set_deferred("monitorable", false)
