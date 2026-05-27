extends Timer

@export var character: CharacterBody2D

var _buffered_input: Callable

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("jump"):
		if not character.jump(): #coyote
			_buffered_input = character.jump
			start()
			
	elif event.is_action_released("jump"):
		character.cancel_jump()
	
	if event.is_action_pressed("run"):
		character.run()
	elif event.is_action_released("run"):
		character.walk()

func _process(_delta: float) -> void:
	character.direction = Input.get_axis("move_left","move_right")
	if not is_stopped():
		if _buffered_input.call():
			stop()
