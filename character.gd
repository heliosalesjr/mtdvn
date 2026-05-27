extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var _move_speed: float = 2560
@export var _acceleration: float = 512
@export var _deceleration: float = 2048

var direction: float 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if direction:
		if velocity.x == 0 or sign(velocity.x) == sign(direction):
			velocity.x = move_toward(velocity.x, direction * _move_speed, _acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * _move_speed, _deceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
		
	move_and_slide()
