extends EnemyStates


func _state_logic(delta : float) -> void:
	match state:
		states.idle:
			parent.move_friction(delta)
		states.walk:
			parent.move_wander(delta)
		states.attack:
			parent.move_friction(delta)
	._state_logic(delta)


func _enter_state(new_state : String, old_state) -> void:
	match new_state:
		states.idle:
			pass
		states.walk:
			parent.set_rand_dir()
			parent.start_change_state_timer()
		states.attack:
			pass
	._enter_state(new_state, old_state)
