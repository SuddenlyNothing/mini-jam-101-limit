extends Node2D

onready var line := $Line2D


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if line.points.size() >= 2:
		line.points[0] = lerp(line.points[0], line.points[1], 10 * delta)


func set_points(p1: Vector2, p2: Vector2) -> void:
	line.points = PoolVector2Array([p1, p2])


func _on_StartTimer_timeout() -> void:
	set_process(true)
