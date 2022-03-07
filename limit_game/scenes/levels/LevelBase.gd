extends Node2D

export(String, FILE, "*.tscn") var next_scene

var exit_song := true

onready var player := $Player
onready var right_bound : float = $RightBottomBound.position.x
onready var bottom_bound : float = $RightBottomBound.position.y
onready var camera := $Player/PlayerCamera
onready var death_wait_timer := $DeathWaitTimer


func _ready() -> void:
	MusicPlayer.set_level_music(true)
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
	exit_song = false
	SceneHandler.restart_scene()


func _on_LevelBase_tree_exiting() -> void:
	if exit_song:
		MusicPlayer.set_level_music(false)
