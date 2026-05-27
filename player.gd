extends Node

@export var character: CharacterBody2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		character.jump()
	elif event.is_action_released("jump"):
		character.cancel_jump()
	
	if event.is_action_pressed("run"):
		character.run()
	elif event.is_action_released("run"):
		character.walk()

func _process(_delta: float) -> void:
	character.direction = Input.get_axis("move_left","move_right")
