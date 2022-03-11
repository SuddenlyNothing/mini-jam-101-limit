extends EnemyStates


func _get_transition(delta : float):
	match state:
		states.idle:
			if parent.is_player_in_activate_cast():
				return states.attack
	return ._get_transition(delta)


func _enter_state(new_state : String, old_state) -> void:
	match new_state:
		states.walk:
			parent.attack_timer.start()
	._enter_state(new_state, old_state)
