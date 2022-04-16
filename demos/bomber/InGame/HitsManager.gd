extends Node2D
export(Resource) var RuleManager
# Listen Rules Manager and spawns explosions and hits

export(PackedScene) var explosion_scene
export(PackedScene) var bomb_scene
export(PackedScene) var punch_scene

func _ready():
	RuleManager.connect("throw_bomb", self, "on_bomb")
	RuleManager.connect("explosion", self, "on_explosion")
	RuleManager.connect("punch", self, "on_punch")

func on_bomb(player, power, spawn_vel):
	var bomb = bomb_scene.instance()
	bomb.setup(power, player.position, spawn_vel)
	add_child(bomb)

func on_punch(player):
	var zone = punch_scene.instance()
	zone._init(player, player.position)
	add_child(zone)

func on_explosion(explostion_position):
	var zone = explosion_scene.instance()
	zone._init(self, explostion_position)
	add_child(zone)
