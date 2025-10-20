extends Behavior


func start(old_state: Behavior = null):
	super(old_state)
	character.die()


func end():
	super()
