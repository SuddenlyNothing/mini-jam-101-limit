extends Enemy

var velocity := Vector2()
var gravity := 2300.0
var max_fall_speed_random_factor := 10.0
var max_fall_speed := 630.0 + (randf() * 2 - 1) * max_fall_speed_random_factor
var jump_force_random_factor := 120.0
var jump_force := 580 + (randf() * 2 - 1) * jump_force_random_factor
var max_y_diff_random_factor := 45.0
var max_y_diff := 40.0 + (randf() * 2 - 1) * max_y_diff_random_factor
var jump_range_random_factor := 40.0
var jump_range := 20.0 + (randf() * 2 - 1) * jump_range_random_factor

var max_speed_random_factor := 80.0
var max_speed := 360.0 + (randf() * 2 - 1) * max_speed_random_factor
var acceleration_time_random_factor := 0.2
var acceleration_time := 0.53 + (randf() * 2 - 1) * acceleration_time_random_factor
var acceleration := max_speed / acceleration_time

var friction_time_random_factor := 0.2
var friction_time := 0.25 + (randf() * 2 - 1) * friction_time_random_factor
var friction := max_speed / friction_time

var attack_dist := 10
var attack_damage := 10.0

var was_on_floor := true

onready var step_sfx := $StepSFX
onready var jump_sfx := $JumpSFX
onready var land_sfx := $LandSFX


func attack() -> void:
	player.hit(attack_damage)
	.attack()


func move_friction(delta: float) -> void:
	_apply_gravity(delta)
	_apply_friction(delta)
	_apply_velocity(delta)


func move_toward_player(delta: float) -> void:
	_apply_gravity(delta)
	_accelerate_toward_player(delta)
	_apply_jump()
	_apply_velocity(delta)


func is_in_range() -> bool:
	return position.distance_to(player.position) <= attack_dist


func check_land() -> void:
	if not was_on_floor and is_on_floor():
		land_sfx.play()
	was_on_floor = is_on_floor()


func _apply_gravity(delta: float) -> void:
	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)


func _apply_jump() -> void:
	if is_on_floor() and (is_on_wall() or (player.position.y + max_y_diff < position.y)
			and abs(player.position.x - position.x) < jump_range):
		velocity.y = -jump_force
		jump_sfx.play()


func _apply_velocity(_delta: float) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)


func _apply_friction(delta: float) -> void:
	var friction_amount := friction * delta
	if friction_amount > abs(velocity.x):
		velocity.x = 0
	else:
		velocity.x -= sign(velocity.x) * friction_amount


func _accelerate_toward_player(delta: float) -> void:
	var dir := 1 if player.position.x > position.x else -1
	velocity.x = clamp(velocity.x + acceleration * delta * dir, -max_speed, max_speed)


func _on_AnimatedSprite_frame_changed() -> void:
	if anim_sprite.animation == "walk":
		match anim_sprite.frame:
			0, 3:
				step_sfx.play()
	._on_AnimatedSprite_frame_changed()
