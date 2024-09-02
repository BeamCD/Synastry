extends Resource

@export var name : String = "Enemy":
	set(value):
		name = value
	get:
		return name
@export var enemy: Resource = null
@export var health:int = 3
@export var damage:int = 2
