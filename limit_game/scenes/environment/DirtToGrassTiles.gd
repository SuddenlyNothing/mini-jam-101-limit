extends TileMap

const GrassParticles := preload("res://scenes/environment/GrassParticles.tscn")

export(bool) var do_spreading := true

onready var grass_tiles := $GrassTiles
onready var grow_sfx := $GrowSFX


func set_tile_to_grass(pos: Vector2) -> void:
	var tile_pos : Vector2 = world_to_map(pos)
	var cell_id : int = get_cellv(tile_pos)
	if cell_id == -1:
		return
	grow_sfx.play()
	var cell_autotile_coord : Vector2 = get_cell_autotile_coord(
			tile_pos.x, tile_pos.y)
	set_cell(tile_pos.x, tile_pos.y, -1)
	grass_tiles.set_cell(tile_pos.x, tile_pos.y, cell_id, false, false,
			false, cell_autotile_coord)
	
	var tile_center : Vector2 = map_to_world(tile_pos) + cell_size / 2
	var grass_particles := GrassParticles.instance()
	grass_particles.position = tile_center
	grass_particles.emitting = true
	add_child(grass_particles)
	
	if not do_spreading:
		return
	
	if randf() < 0.9:
		var timer = Timer.new()
		timer.connect("timeout", self, "set_tile_to_grass",
				[tile_center + Vector2(0, -cell_size.x)])
		timer.connect("timeout", timer, "queue_free")
		timer.one_shot = true
		add_child(timer)
		timer.start(0.1)
	if randf() < 0.5:
		var timer = Timer.new()
		timer.connect("timeout", self, "set_tile_to_grass",
				[tile_center + Vector2(0, cell_size.x)])
		timer.connect("timeout", timer, "queue_free")
		timer.one_shot = true
		add_child(timer)
		timer.start(0.1)
	if randf() < 0.4:
		var timer = Timer.new()
		timer.connect("timeout", self, "set_tile_to_grass",
				[tile_center + Vector2(cell_size.x, 0)])
		timer.connect("timeout", timer, "queue_free")
		timer.one_shot = true
		add_child(timer)
		timer.start(0.1)
	if randf() < 0.4:
		var timer = Timer.new()
		timer.connect("timeout", self, "set_tile_to_grass",
				[tile_center + Vector2(-cell_size.x, 0)])
		timer.connect("timeout", timer, "queue_free")
		timer.one_shot = true
		add_child(timer)
		timer.start(0.1)
