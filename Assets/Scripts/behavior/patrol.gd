class_name PatrolBehavior extends Behavior


@export var direction: Vector2
@export var destination: Vector2
@export var duration: float
@export_range(1, 3, 0.25) var max_duration: float
@export_category("Behavior Transitions")
@export var chase : Behavior
@export var idle : Behavior


func update(delta: float) -> Behavior:
	if duration >= 0:
		duration -= delta
	else:
		random_patrol()
	return null


func start():
	super()
	random_patrol()


func end():
	direction = Vector2.ZERO


func physics_update(_delta: float) -> Behavior:
	if character.is_on_wall():
		direction *= -1
	if character:
		character.velocity = direction * character.speed
	if character.target:
		return chase 
	return null


func random_patrol():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	duration = randf_range(1,max_duration)
