extends Node2D

export(NodePath) var bubble_path
export(NodePath) onready var bubble_container = get_node(bubble_container) as Control
export(NodePath) onready var bubble_anchor = get_node(bubble_anchor) as Node2D
export(NodePath) onready var bubble_tail = get_node(bubble_tail) as Polygon2D
export(NodePath) onready var bubble_effect = get_node(bubble_effect) as ColorRect
export(NodePath) onready var bubble_tween = get_node(bubble_tween) as Tween
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer

signal open
signal close

var bubble_node = null
var actor_anchor = null

var container_width = 0
var container_height = 0
var tail_width = 0
var viewport = null

var selected_choice = 0
var choice_count = 0

func set_choices(choices_list : Array):
	choice_count = choices_list.size()

func increment_choice_selection(value):
	selected_choice += posmod(selected_choice + value, choice_count)

func _ready():
	bubble_node = get_node(bubble_path)
	viewport = get_viewport()
	bubble_node.text = ""
	bubble_container.connect("item_rect_changed", self, "_on_BubbleContainer_item_rect_changed")

func _process(delta):
	if actor_anchor == null: return
	var origin = actor_anchor.get_global_transform_with_canvas().origin
	bubble_anchor.position = actor_anchor.get_global_transform_with_canvas().origin
	bubble_anchor.position.y -= 150
	bubble_anchor.position.x = clamp(bubble_anchor.position.x, container_width, viewport.size.x - container_width)
	bubble_anchor.position.y = clamp(bubble_anchor.position.y, container_height, viewport.size.y - container_height)
	var tail_end : Vector2 = origin - Vector2(0, 50) - bubble_anchor.position
	bubble_tail.polygon[2] = origin - Vector2(0, 50) - bubble_anchor.position
	var a = tail_end.angle()
	bubble_tail.polygon[0] = Vector2(0,tail_width).rotated(a)
	bubble_tail.polygon[1] = Vector2(0,-tail_width).rotated(a)

func open():
	animation_player.play("Pop")
	yield(animation_player, "animation_finished")
	emit_signal("open")
	
func close():
	animation_player.play_backwards("Pop")
	yield(animation_player, "animation_finished")
	emit_signal("close")
	
func write(text : String):
	var t : float = float(text.length())*.02
	bubble_node.text = text
	
func _on_BubbleContainer_item_rect_changed():
	var w = bubble_container.rect_size.x
	var h = bubble_container.rect_size.y
	container_width = w / 2
	container_height = h / 2
	tail_width = container_width * 0.2
	var ratio
	if w > h:
		ratio = Vector2(1,w/h)
	else:
		ratio = Vector2(h/w,1)
	bubble_effect.material.set_shader_param("ratio", ratio)
