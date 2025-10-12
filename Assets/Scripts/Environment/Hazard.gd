class_name Hazard extends Resource
## An environmental danger such as a floor trap.

enum HazardType { ENVIRONMENTAL, TRAP }

@export var name: String
@export var type: HazardType
@export var damage: int
@export var is_animated: bool
@export var texture: Texture2D
@export var sprite_frames: Resource
