extends Node2D

export(String, FILE, "*.tscn") var next_scene

onready var player := $Player
onready var right_bound : float = $RightBottomBound.position.x
onready var bottom_bound : float = $RightBottomBound.position.y
onready var camera := $Player/PlayerCamera
onready var death_wait_timer := $DeathWaitTimer


func _ready() -> void:
	camera.limit_right = right_bound
	camera.limit_bottom = bottom_bound


func _process(delta: float) -> void:
	if player.position.x >= right_bound:
		SceneHandler.goto_scene(next_scene)
		set_process(false)
	if player.position.y > bottom_bound:
		player.hit(200)
		set_process(false)


func _on_DeathWaitTimer_timeout() -> void:
	SceneHandler.restart_scene()
