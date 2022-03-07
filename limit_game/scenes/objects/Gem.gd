extends Area2D

const GemCollectParticles := preload("res://scenes/objects/GemCollectParticles.tscn")

export(NodePath) var spike_path


func _on_Gem_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var sfx := AudioStreamPlayer.new()
	sfx.bus = "SFX"
	sfx.stream = preload("res://assets/sfx/level_complete.wav")
	get_parent().add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx, "queue_free")
	
	var gcp := GemCollectParticles.instance()
	gcp.position = position
	get_parent().add_child(gcp)
	
	var spike = get_node(spike_path)
	spike.destroy()
	queue_free()
