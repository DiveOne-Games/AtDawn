class_name Weapon extends Resource

enum WeaponType { Melee, Projectile }
enum DamageType { Physical, Magic }

@export var name: String
@export var texture: Texture2D
@export var min_damage: int
@export var max_damage: int
@export_range(0,1,0.01) var hit_chance: float
@export_range(0,1,0.01) var crit_chance: float
@export var crit_modifier: float = 1.5
@export var type: WeaponType


func damage():
	return randi_range(min_damage, max_damage)
