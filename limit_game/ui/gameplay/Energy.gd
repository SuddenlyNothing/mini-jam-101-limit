extends TextureProgress

var dash_cost := 25
var increment_amount := 1


func can_dash() -> bool:
	return value >= 25


func use_dash() -> void:
	value -= dash_cost


func _on_AutoIncrement_timeout() -> void:
	value += increment_amount
