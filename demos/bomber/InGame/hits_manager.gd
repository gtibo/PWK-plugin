extends Node2D
export(Resource) var RuleManager
export(Resource) var main_sfx_manager
# Listen Rules Manager and spawns explosions and hits
export(PackedScene) var explosion_scene
export(PackedScene) var explosion_vfx_scene
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
	main_sfx_manager.play("punch")
	var zone = punch_scene.instance()
	zone.setup(player, player.position)
	add_child(zone)

func on_explosion(explostion_position, power):
	var zone = explosion_scene.instance()
	zone.setup(self, explostion_position, power)
	add_child(zone)
	var explo = explosion_vfx_scene.instance()
	explo.setup(explostion_position, power)
	add_child(explo)
