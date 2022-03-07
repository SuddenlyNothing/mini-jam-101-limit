extends Camera2D

func _process(delta: float) -> void:
	position += delta * Vector2(Input.get_action_strength("right") -
			Input.get_action_strength("left"), Input.get_action_strength("down") -
			Input.get_action_strength("up")) * 500
