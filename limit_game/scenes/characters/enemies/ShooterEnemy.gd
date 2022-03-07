extends Enemy

const Shot := preload("res://scenes/characters/enemies/Shot.tscn")

var gravity := 2300.0
var max_fall_speed_random_factor := 10.0
var max_fall_speed := 630.0 + (randf() * 2 - 1) * max_fall_speed_random_factor

var max_speed_random_factor := 10.0
var max_speed := 40.0 + (randf() * 2 - 1) * max_speed_random_factor
var acceleration_time := 0.1
var acceleration := max_speed / acceleration_time

var friction_time_random_factor := 0.05
var friction_time := 0.15 + (randf() * 2 - 1) * friction_time_random_factor
var friction := max_speed / friction_time

var velocity := Vector2()

var min_change_dir_time := 0.5
var max_change_dir_time := 2.5

var x_dir = 1

onready var left_ground_cast := $LeftGroundCast
onready var right_ground_cast := $RightGroundCast
onready var change_state_timer := $ChangeStateTimer
onready var shot_position : Vector2 = $ShotPosition.position
onready var step_sfx := $StepSFX


func attack() -> void:
	var shot := Shot.instance()
	shot.position = position + shot_position
	shot.dir = position.direction_to(player.position)
	get_parent().add_child(shot)
	.attack()


func move_friction(delta: float) -> void:
	_apply_gravity(delta)
	_apply_friction(delta)
	_apply_velocity(delta)


func move_wander(delta: float) -> void:
	_set_x_dir()
	_apply_gravity(delta)
	_apply_acceleration(delta)
	_apply_velocity(delta)


func start_change_state_timer() -> void:
	change_state_timer.start(randf() * (max_change_dir_time - min_change_dir_time) +
			min_change_dir_time)


func set_rand_dir() -> void:
	x_dir = 1 if randf() > 0.5 else -1


func _apply_acceleration(delta: float) -> void:
	velocity.x = clamp(velocity.x + acceleration * x_dir * delta, -max_speed, max_speed)


func _set_x_dir() -> void:
	if not left_ground_cast.is_colliding() and x_dir < 0:
		x_dir *= -1
	elif not right_ground_cast.is_colliding() and x_dir > 0:
		x_dir *= -1


func _apply_gravity(delta: float) -> void:
	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)


func _apply_velocity(_delta: float) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)


func _apply_friction(delta: float) -> void:
	var friction_amount := friction * delta
	if friction_amount > abs(velocity.x):
		velocity.x = 0
	else:
		velocity.x -= sign(velocity.x) * friction_amount


func _on_ChangeStateTimer_timeout() -> void:
	if randf() > 0.5:
		enemy_states.call_deferred("set_state", "walk")
	else:
		enemy_states.call_deferred("set_state", "attack")


func _on_AnimatedSprite_frame_changed() -> void:
	if anim_sprite.animation == "walk":
		match anim_sprite.frame:
			0, 3:
				step_sfx.play()
	._on_AnimatedSprite_frame_changed()
