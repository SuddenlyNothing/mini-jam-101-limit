extends TileMap

const SpikeDestroyParticles := preload("res://scenes/environment/" +
		"SpikeDestroyParticles.tscn")

func destroy() -> void:
	for cell in get_used_cells():
		set_cell(cell.x, cell.y, -1)
		var cell_center = map_to_world(cell) + cell_size / 2
		var sdp := SpikeDestroyParticles.instance()
		sdp.position = cell_center
		get_parent().add_child(sdp)
		yield(get_tree().create_timer(0.05, false), "timeout")
	queue_free()
