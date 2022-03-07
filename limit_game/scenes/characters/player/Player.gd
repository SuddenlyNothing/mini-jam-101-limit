extends KinematicBody2D
class_name Player
# warnings-disable

signal died

const DashParticle := preload("res://scenes/characters/player/DashParticle.tscn")

var jump_height : float = 85.0
var jump_time_to_peak : float = 0.25
var jump_time_to_descent : float = 0.3

var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity : float = ((-2.0 * jump_height) /
		(jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity : float = ((-2.0 * jump_height) /
		(jump_time_to_descent * jump_time_to_descent)) * -1.0

var max_move_speed : float = 250.0
var max_fall_speed : float = fall_gravity * jump_time_to_descent

var dash_speed : float = 600.0
var dash_initial_dist : float = 200
var is_dashing := false
var dash_damage : int = 1

var can_double_jump := true

var acceleration_time : float = 0.13
var turn_acceleration_time : float = 0.08
var air_friction_time : float = 0.2
var ground_friction_time : float = 0.15

var acceleration : float = max_move_speed / acceleration_time
var turn_acceleration : float = max_move_speed / turn_acceleration_time
var air_friction : float = max_move_speed / air_friction_time
var ground_friction : float = max_move_speed / ground_friction_time

var x_input := 0
var velocity := Vector2()

var snap := Vector2.DOWN * 0.5
var up := Vector2.UP

var enemies_in_hitbox : Dictionary = {}

var applied_jump_release := false

var is_dead := false

onready var flip := $Flip
onready var anim_sprite := $Flip/AnimatedSprite
onready var coyote_timer := $CoyoteTimer
onready var jump_buffer_timer := $JumpBufferTimer
onready var dash_buffer_timer := $DashBufferTimer
onready var hud := $PlayerHud
onready var player_camera := $PlayerCamera
onready var player_states := $PlayerStates
onready var hitbox_ray_cast := $HitboxRayCast
onready var dash_empty_sfx := $DashEmptySFX
onready var dash_start_sfx := $DashStartSFX
onready var footstep_sfx := $FootstepSFX
onready var jump_sfx := $JumpSFX
onready var land_sfx := $LandSFX
onready var hurt_sfx := $HurtSFX


func _process(delta: float) -> void:
	set_x_input()
	if Input.is_action_just_pressed("up"):
		jump_buffer_timer.start()
	if Input.is_action_just_pressed("dash") or not dash_buffer_timer.is_stopped():
		if hud.can_dash():
			if x_input != 0:
				set_dashing(true, x_input)
				dash_buffer_timer.stop()
				hud.use_dash()
			elif dash_buffer_timer.is_stopped():
				dash_buffer_timer.start()
		else:
			dash_empty_sfx.play()


func hit(damage: float) -> void:
	if is_dead:
		return
	if hud.add_health(-damage):
		is_dead = true
		player_states.call_deferred("set_state", "death")
	player_camera.shake()
	hurt_sfx.play()


func move(delta: float, is_on_ground: bool, is_falling: bool, dead: bool = false) -> void:
	apply_acceleration(delta, dead)
	apply_velocity(delta, is_on_ground)
	apply_friction(delta, is_on_ground, dead)
	apply_gravity(delta, is_falling)


func can_jump(is_on_ground: bool) -> bool:
	var pressed_up = Input.is_action_just_pressed("up")
	if is_on_ground:
		if pressed_up:
			return true
		if not jump_buffer_timer.is_stopped():
			return true
	else:
		if pressed_up:
			if not coyote_timer.is_stopped():
				return true
			if can_double_jump:
				can_double_jump = false
				return true
	return false


func set_facing() -> void:
	if x_input > 0 and flip.scale.x < 0:
		flip.scale.x *= -1
	elif x_input < 0 and flip.scale.x > 0:
		flip.scale.x *= -1


func set_x_input() -> void:
	if is_dead:
		x_input = 0
		return
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")


func apply_acceleration(delta: float, dead: bool = false) -> void:
	if dead:
		return
	if abs(velocity.x) <= max_move_speed:
		if is_dashing:
			set_dashing(false)
		if sign(x_input) == sign(velocity.x) or velocity.x == 0:
			velocity.x = clamp(velocity.x + acceleration * x_input * delta,
					-max_move_speed, max_move_speed)
		else:
			velocity.x = clamp(velocity.x + turn_acceleration * x_input * delta,
					-max_move_speed, max_move_speed)
	else:
		if sign(velocity.x) != sign(x_input):
			velocity.x += turn_acceleration * x_input * delta


func apply_friction(delta: float, is_on_ground: bool, dead: bool = false) -> void:
	if x_input != 0 and not dead:
		return
	var friction : float = 0
	if is_on_ground:
		friction = ground_friction
	else:
		friction = air_friction
	var friction_amount := friction * delta
	if abs(velocity.x) <= friction_amount / 2.0:
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= friction_amount
	else:
		velocity.x += friction_amount


func apply_velocity(delta: float, is_on_ground: bool) -> void:
	if is_on_ground:
		velocity = move_and_slide_with_snap(velocity, snap, up)
	else:
		velocity = move_and_slide(velocity, up)
	if get_slide_count():
		var collision := get_slide_collision(0)
		if collision.collider.is_in_group("dirt_to_grass_tiles"):
			var tile_pos = collision.position - collision.normal * 10
			collision.collider.set_tile_to_grass(tile_pos)
		elif collision.collider.is_in_group("deadly"):
			hit(100)


func apply_gravity(delta: float, is_falling: bool) -> void:
	if is_falling:
		velocity.y = min(velocity.y + fall_gravity * delta, max_fall_speed)
	else:
		velocity.y = min(velocity.y + jump_gravity * delta, max_fall_speed)


func apply_jump_release() -> void:
	if Input.is_action_just_released("up") and not applied_jump_release:
		velocity.y += abs(velocity.y) / 2
		applied_jump_release = true


func set_dashing(val: bool, dir: int = 0) -> void:
	is_dashing = val
	if dir:
		_dash(dir)
	else:
		if anim_sprite.animation == "run":
			anim_sprite.play("walk")


func _dash(dir: int) -> void:
	dash_start_sfx.play()
	velocity.x = dash_speed * dir
	if anim_sprite.animation == "walk":
		anim_sprite.play("run")
	var old_pos = position
	move_and_collide(Vector2.RIGHT * dir * dash_initial_dist)
	var dash_particle := DashParticle.instance()
	get_parent().add_child(dash_particle)
	dash_particle.set_points(old_pos, position)
	for enemy in enemies_in_hitbox:
		hitbox_ray_cast.cast_to = enemy.position - position
		hitbox_ray_cast.force_raycast_update()
		if not hitbox_ray_cast.is_colliding() or hitbox_ray_cast.get_collider() == enemy:
			enemy.hit(dash_damage)
			player_camera.shake()


func jump() -> void:
	jump_sfx.play()
	velocity.y = jump_velocity


func update_grounded(is_grounded: bool) -> void:
	player_camera.update_grounded(is_grounded)


func play_anim(anim: String) -> void:
	if anim_sprite.animation == anim:
		return
	if is_dashing and anim == "walk":
		anim_sprite.play("run")
		return
	anim_sprite.play(anim)


func _on_Hitbox_body_entered(body: Node) -> void:
	if not body.is_in_group("enemy"):
		return
	enemies_in_hitbox[body] = 1


func _on_Hitbox_body_exited(body: Node) -> void:
	if not body.is_in_group("enemy"):
		return
	enemies_in_hitbox.erase(body)


func _on_AnimatedSprite_frame_changed() -> void:
	match anim_sprite.animation:
		"walk":
			match anim_sprite.frame:
				0, 3:
					footstep_sfx.play()
		"run":
			match anim_sprite.frame:
				0, 3:
					footstep_sfx.play()
