extends Area

export(Resource) var story_manager
export(String) var event_name = ""

export(String, "entered", "exited") var execute_on

func _ready():
	connect("area_" + execute_on, self, "area_event")
	
func area_event(_area):
	story_manager.read_event(self, event_name)
