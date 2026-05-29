extends AudioStreamPlayer2D


func play_random() -> void:
	pitch_scale = randf_range(0.5, 2)
	play()
