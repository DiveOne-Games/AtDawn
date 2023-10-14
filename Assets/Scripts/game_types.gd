extends Node

enum DamageType { Physical, Magic }
enum ItemType { Gold, Collectible, Equipment }

enum Group { Enemies, Projectiles }
const Enemies = 'enemies'
const Projectiles = 'projectiles'


func get_game_group(key: int):
	match key:
		Group.Enemies:
			return Enemies
		Group.Projectiles:
			return Projectiles
		var no_group:
			print_debug('No matching group found.')


