class_name DeathState extends PlayState


func process(_delta: float) -> PlayState:
	character.die()
	return null
