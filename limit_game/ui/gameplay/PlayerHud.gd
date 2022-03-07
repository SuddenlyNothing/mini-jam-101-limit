extends CanvasLayer

onready var health := $M/V/Health
onready var energy := $M/V/Energy


func use_dash() -> void:
	energy.use_dash()


func can_dash() -> bool:
	return energy.can_dash()


func add_health(val: float) -> bool:
	return health.set_health(health.health + val)


func set_health(val: float) -> bool:
	return health.set_health(val)
