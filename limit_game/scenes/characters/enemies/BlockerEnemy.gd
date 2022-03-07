extends Enemy

export(Array, PackedScene) var enemies : Array

var shoot_force := 5000.0

onready var spawn_position : Vector2 = $SpawnPosition.position
onready var attack_timer := $AttackTimer


func attack() -> void:
	var enemy = enemies[round(randf() * (enemies.size() - 1))].instance()
	enemy.position = position + spawn_position
	enemy.agro_on_start = true
	enemy.player = player
	.attack()
	get_parent().add_child(enemy)


func _on_AttackTimer_timeout() -> void:
	enemy_states.call_deferred("set_state", "attack")
