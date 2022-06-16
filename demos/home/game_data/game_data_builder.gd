extends Resource
class_name game_data

export(String) var game_name = "Untilted"
export(String, MULTILINE) var game_synopsis = "Game synopsis"
export(String, MULTILINE) var game_technical_info = "Game technical information"
export(String) var player_count = "1 Player"
export(Texture) var vignette
export(String, FILE, "*.tscn") var main_scene_path
