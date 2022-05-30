extends Navigation

export(Resource) var navigation_manager

func _ready():
	navigation_manager.set_current(self)
