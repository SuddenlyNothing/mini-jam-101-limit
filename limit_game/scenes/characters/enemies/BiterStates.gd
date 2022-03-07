extends EnemyStates


func _state_logic(delta : float) -> void:
	parent.check_land()
	match state:
		states.idle:
			parent.move_friction(delta)
		states.walk:
			parent.move_toward_player(delta)
		states.attack:
			parent.move_friction(delta)
	._state_logic(delta)


func _get_transition(delta : float):
	match state:
		states.walk:
			if parent.is_in_range():
				return states.attack
	return ._get_transition(delta)
