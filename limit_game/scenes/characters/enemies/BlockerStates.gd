extends EnemyStates


func _enter_state(new_state : String, old_state) -> void:
	match new_state:
		states.walk:
			parent.attack_timer.start()
	._enter_state(new_state, old_state)
