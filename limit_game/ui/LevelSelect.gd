extends Control

onready var dirt_to_grass := $DirtToGrassTiles


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		dirt_to_grass.set_tile_to_grass(event.position)
