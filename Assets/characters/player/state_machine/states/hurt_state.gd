class_name HurtState extends PlayState

## How quickly a character recovers after being hit.
@export_range(0, 1, 0.05) var recovery_threshold : float = 0.1 
## How long the player can't move while being hit.
@export_range(0, 1, 0.05) var recovery_delay: float = 0.3
## Delay timer for restoring player control.
var delay : float = 0.3 


func start():
	super()
	

func end():
	super()
	character.is_hurt = false
	delay = recovery_delay


func process(delta: float) -> PlayState:
	delay -= delta
	if not character.is_dead and delay <= recovery_threshold:
		return move_state
	return null
