extends Node2D

onready var camera := $Player/PlayerCamera


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		camera.current = not camera.current
