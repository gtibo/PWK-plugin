extends Area2D

export(Resource) var main_focus_manager
export(String) var zone_name = ""

func _on_Zone_area_entered(area):
	if area.is_in_group("FocusTrigger"):
		main_focus_manager.focus(zone_name)
		
func _on_Zone_area_exited(area):
	if area.is_in_group("FocusTrigger"):
		main_focus_manager.defocus(zone_name)
