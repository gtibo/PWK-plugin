extends Node2D
export(NodePath) onready var choice_container = get_node(choice_container) as MarginContainer
export(NodePath) onready var choice_holder = get_node(choice_holder) as VBoxContainer
export(PackedScene) var choice_scene

export(NodePath) onready var bubble_label = get_node(bubble_label) as Label
export(NodePath) onready var bubble_container = get_node(bubble_container) as Control
export(NodePath) onready var bubble_anchor = get_node(bubble_anchor) as Node2D
export(NodePath) onready var bubble_tail = get_node(bubble_tail) as Polygon2D
export(NodePath) onready var bubble_effect = get_node(bubble_effect) as ColorRect
export(NodePath) onready var bubble_tween = get_node(bubble_tween) as Tween
export(NodePath) onready var text_tween = get_node(text_tween) as Tween

signal wrote

var actor_anchor = null

var container_width = 0
var container_height = 0
var tail_width = 0
onready var viewport = get_viewport()

signal opened
signal closed

func open():
	bubble_effect.rect_min_size = Vector2.ZERO
	$AnimationPlayer.play("Open")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("opened")
	
func close():
	bubble_label.text = ""
	$AnimationPlayer.play_backwards("Open")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("closed")
	actor_anchor = null

func set_color(color):
	bubble_effect.color = color
	bubble_tail.color = color
	
func set_choices(choices_list : Array):
	yield(self, "wrote")
	choice_container.show()
	for choice in choices_list:
		var choice_box = choice_scene.instance()
		choice_box.text = choice.name
		choice_holder.add_child(choice_box)
	select_choice(null, 0)
func select_choice(old_index, new_index):
	if old_index != null: choice_holder.get_child(old_index).deselect()
	choice_holder.get_child(new_index).select()

func remove_choices():
	choice_container.hide()
	for child in choice_holder.get_children():
		child.queue_free()

func _ready():
	bubble_label.text = ""
	bubble_container.connect("item_rect_changed", self, "_on_BubbleContainer_item_rect_changed")
	choice_container.hide()
	
func _process(_delta):
	if actor_anchor == null: return
	var origin = actor_anchor.get_screen_position()
	bubble_anchor.position = origin
	bubble_anchor.position.y -= 200
	bubble_anchor.position.x = clamp(bubble_anchor.position.x, container_width, viewport.size.x - container_width)
	bubble_anchor.position.y = clamp(bubble_anchor.position.y, container_height, viewport.size.y - container_height)
	var tail_end : Vector2 = origin - Vector2(0, 50) - bubble_anchor.position
	bubble_tail.polygon[2] = origin - Vector2(0, 50) - bubble_anchor.position
	var a = tail_end.angle()
	bubble_tail.polygon[0] = Vector2(0,tail_width).rotated(a)
	bubble_tail.polygon[1] = Vector2(0,-tail_width).rotated(a)
	
func write(text : String):
	var t : float = float(text.length())*.02
	bubble_label.modulate.a = 0
	bubble_label.text = text
	yield(bubble_tween, "tween_completed")
	text_tween.interpolate_property(bubble_label, "percent_visible", 0, 1, t, false, false, 0.1)
	text_tween.start()
	yield(text_tween, "tween_started")
	bubble_label.modulate.a = 1
	yield(text_tween, "tween_completed")
	emit_signal("wrote")
	
func _on_BubbleContainer_item_rect_changed():
	var w = bubble_container.rect_size.x
	var h = bubble_container.rect_size.y
	container_width = w / 2
	container_height = h / 2
	tail_width = min(w,h) * 0.1
	var ratio
	if w > h:
		ratio = Vector2(1,w/h)
	else:
		ratio = Vector2(h/w,1)
	bubble_effect.material.set_shader_param("ratio", ratio)
	bubble_tween.interpolate_property(bubble_effect, "rect_min_size", bubble_effect.rect_min_size, bubble_container.rect_size, 0.6,
	Tween.TRANS_BACK)
	bubble_tween.start()
