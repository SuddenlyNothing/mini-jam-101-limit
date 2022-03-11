extends TileMap

const SpikeDestroyParticles := preload("res://scenes/environment/" +
		"SpikeDestroyParticles.tscn")

var cells_to_destroy := []

onready var timer := $Timer


func destroy() -> void:
	cells_to_destroy = get_used_cells()
	destroy_cell()


func destroy_cell() -> void:
	if cells_to_destroy.empty():
		queue_free()
	else:
		var cell = cells_to_destroy.pop_front()
		set_cell(cell.x, cell.y, -1)
		var cell_center = map_to_world(cell) + cell_size / 2
		var sdp := SpikeDestroyParticles.instance()
		sdp.position = cell_center
		get_parent().add_child(sdp)
		timer.start()


func _on_Timer_timeout() -> void:
	destroy_cell()
