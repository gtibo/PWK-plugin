extends Area

export(Resource) var main_focus_manager
export(String) var zone_name = ""

func _ready():
	connect("area_entered", self, "on_area_entered")
	connect("area_exited", self, "on_area_exited")

func on_area_entered(area):
	if area.is_in_group("FocusTrigger"):
		main_focus_manager.focus(zone_name)
		
func on_area_exited(area):
	if area.is_in_group("FocusTrigger"):
		main_focus_manager.defocus(zone_name)
