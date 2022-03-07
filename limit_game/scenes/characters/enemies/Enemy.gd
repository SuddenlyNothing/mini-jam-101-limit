class_name Enemy
extends KinematicBody2D

const EnemyDeathParticles := preload("res://scenes/characters/" +
		"enemies/EnemyDeathParticles.tscn")
const GoopSlam := preload("res://scenes/characters/enemies/GoopSlam.tscn")

export var agro_on_start := false
export(int, 10) var attack_frame := 1
export(int) var health := 1
export(Vector2) var death_particles_rect_extents := Vector2.ONE

var is_player_in_activate_area := false
var player : Player

onready var anim_sprite := $AnimatedSprite
onready var activate_cast := $ActivateCast
onready var enemy_states := $EnemyStates
onready var hit_flash_tween := $HitFlashTween
onready var goop_hurt := $GoopHurt
onready var attack_sfx := $AttackSFX


func _ready() -> void:
	if agro_on_start:
		enemy_states.call_deferred("set_state", "walk")


# Override to implement the attack
func attack() -> void:
	attack_sfx.play()


func hit(damage: int) -> void:
	if health <= 0:
		return
	health -= damage
	if health <= 0:
		var goop_slam := GoopSlam.instance()
		goop_slam.position = position
		get_parent().add_child(goop_slam)
		var enemy_death_particles := EnemyDeathParticles.instance()
		enemy_death_particles.position = position
		enemy_death_particles.emitting = true
		enemy_death_particles.emission_rect_extents = death_particles_rect_extents
		get_parent().add_child(enemy_death_particles)
		queue_free()
	else:
		goop_hurt.play()
		hit_flash_tween.interpolate_property(anim_sprite.get_material(),
			"shader_param/hit_strength", 1, 0, 0.2)
		hit_flash_tween.start()


func set_facing() -> void:
	if position.x > player.position.x:
		if anim_sprite.scale.x > 0:
			anim_sprite.scale.x *= -1
	else:
		if anim_sprite.scale.x < 0:
			anim_sprite.scale.x *= -1


func is_player_in_activate_cast() -> bool:
	if is_player_in_activate_area:
		activate_cast.cast_to = player.position - position
		activate_cast.force_raycast_update()
		if activate_cast.is_colliding() and activate_cast.get_collider() == player:
			return true
	return false


func play_anim(anim: String) -> void:
	if anim_sprite.is_playing() and anim_sprite.animation == anim:
		return
	anim_sprite.play(anim)
	anim_sprite.set_frame(0)


func _on_ActivateArea_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if not player:
		player = body
	is_player_in_activate_area = true


func _on_ActivateArea_body_exited(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	is_player_in_activate_area = false


func _on_AnimatedSprite_animation_finished() -> void:
	if anim_sprite.animation == "attack":
		enemy_states.call_deferred("set_state", "walk")


func _on_AnimatedSprite_frame_changed() -> void:
	if anim_sprite.animation == "attack" and anim_sprite.frame == attack_frame:
		attack()
