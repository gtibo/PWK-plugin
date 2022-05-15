extends Resource
class_name DialogueManager

signal dialogue_start
signal dialogue_end

export(String, DIR) var dialogues_dir_path

var current_dialogue_data = null

func start(dialogue_name):
	var dialogue_path = dialogues_dir_path + "/" +dialogue_name + ".json";
	var file = File.new()
	file.open(dialogue_path, file.READ)
	var text = file.get_as_text()
	file.close()
	current_dialogue_data = JSON.parse(text).result
	emit_signal("dialogue_start")

func end():
	current_dialogue_data = null
	emit_signal("dialogue_end")
