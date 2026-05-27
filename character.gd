extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var _move_speed: float = 256
@export var _acceleration: float = 512
@export var _deceleration: float = 2048
@export var _jump_height: float = 256
@onready var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")
@onready var _jump_force: float = sqrt(_gravity * _jump_height * 2) * -1

var is_jumping: bool = false

var direction: float 

func jump() -> void:
	if is_on_floor():
		velocity.y = _jump_force
		is_jumping = true
		
func cancel_jump() -> void:
	if velocity.y < 0:
		velocity.y /=2
	
func _physics_process(delta: float) -> void:
	if is_jumping and velocity.y >= 0:
		is_jumping = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if direction:
		if velocity.x == 0 or sign(velocity.x) == sign(direction):
			velocity.x = move_toward(velocity.x, direction * _move_speed, _acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * _move_speed, _deceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
		
	move_and_slide()
