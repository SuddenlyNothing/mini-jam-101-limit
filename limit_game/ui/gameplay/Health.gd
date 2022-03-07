extends TextureProgress

var health := value setget set_health
var health_lerp := 10


func _process(delta: float) -> void:
	value = lerp(value, health, health_lerp * delta)


func set_health(val: float) -> bool:
	health = val
	return health <= 0
