extends MarginContainer

export(NodePath) onready var bubble_effect = get_node(bubble_effect) as ColorRect
export(NodePath) onready var bubble_container = get_node(bubble_container) as MarginContainer

func _ready():
	bubble_effect.material = bubble_effect.material.duplicate()
	connect("item_rect_changed", self, "_on_item_rect_changed")
	
func _on_item_rect_changed():
	var w = rect_size.x
	var h = rect_size.y
	var ratio
	if w > h:
		ratio = Vector2(1,w/h)
	else:
		ratio = Vector2(h/w,1)
	bubble_effect.material.set_shader_param("ratio", ratio)
	rect_position = Vector2(-bubble_container.rect_size.x / 2 + w * .1, h * .3)


