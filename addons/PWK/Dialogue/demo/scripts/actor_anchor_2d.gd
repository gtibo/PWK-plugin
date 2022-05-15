extends Node2D
export(Resource) var current_actor

func _ready():
	if current_actor == null: return
	current_actor.anchor = self
