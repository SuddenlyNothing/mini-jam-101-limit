extends AudioStreamPlayer

export(Array, AudioStream) var audio_streams


func play(from_position: float = 0.0) -> void:
	stream = audio_streams[round(randf() * (audio_streams.size() - 1))]
	.play(from_position)
