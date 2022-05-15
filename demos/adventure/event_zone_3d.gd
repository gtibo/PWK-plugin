extends Area

export(Resource) var story_manager
export(String) var event_name = ""

func _ready():
	connect("area_exited", self, "on_area_entered")
	
func on_area_entered(_area):
	story_manager.read_event(self, event_name)
