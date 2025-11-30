extends Node

enum DamageType { Physical, Magic }
enum ItemType { Gold, Collectible, Equipment }
enum ProjectileType { Elemental, Arrow, Bullet }
enum UnitType { Monster, Npc, Creature, Boss }
enum Group { Enemies, Projectiles }
enum AttackStates { Light, Medium, Heavy, Combo }

const Enemies = 'enemies'
const Projectiles = 'projectiles'


func get_game_group(key: int):
	match key:
		Group.Enemies:
			return Enemies
		Group.Projectiles:
			return Projectiles
		var _no_group:
			print_debug('No matching group found.')
