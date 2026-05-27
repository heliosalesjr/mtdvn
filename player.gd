extends Node

@export var character: CharacterBody2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character.direction = Input.get_axis("move_left","move_right")
