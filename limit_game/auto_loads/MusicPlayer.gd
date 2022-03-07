extends Node

onready var mus_base := $mus_base


func set_level_music(play: bool) -> void:
	if play:
		if not mus_base.playing:
			mus_base.play()
	else:
		mus_base.stop()
