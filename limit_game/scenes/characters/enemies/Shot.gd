extends CPUParticles2D

const ExplosionParticle := preload("res://scenes/characters/enemies/"+
		"ExplosionParticle.tscn")

var dir := Vector2.RIGHT
var speed := 300
var damage := 10

onready var collision_shape := $Area2D/CollisionShape2D
onready var finish_timer := $FinishTimer
onready var projectile_hit_sfx := $ProjectileHitSFX


func _physics_process(delta: float) -> void:
	position += speed * dir * delta


func _on_KillTimer_timeout() -> void:
	emitting = false
	collision_shape.call_deferred("set_disabled", true)
	set_physics_process(false)
	finish_timer.start()


func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	collision_shape.call_deferred("set_disabled", true)
	body.hit(damage)
	emitting = false
	set_physics_process(false)
	create_explosion()
	projectile_hit_sfx.play()
	finish_timer.start()


func create_explosion() -> void:
	var explosion_particle := ExplosionParticle.instance()
	add_child(explosion_particle)
	explosion_particle.emitting = true
