extends CharacterBody2D

@export_category("Locomotion")
@export var _walk_speed: float = 256
@export var _run_speed: float = 512
var _move_speed: float
@export var _acceleration: float = 512
@export var _deceleration: float = 2048
var direction: float 

@onready var sprite_2d: Sprite2D = $Sprite2D

@export_category("Jumping")
@export var _jump_height: float = 256
@export var _gravity_multiplier: float = 1 #this is used to control the gravity for the player, but having that on other characters might help them feel lighter or heavier according to the desired effect.
@export var _air_control: float = 0.5
@export var _air_brakes: float = 0.5
@export var _terminal_velocity: float = 2048
@onready var _coyote: Timer = get_node_or_null("Coyote") 
@onready var _gravity: float = ProjectSettings.get("physics/2d/default_gravity") * _gravity_multiplier
@onready var _jump_force: float = sqrt(_gravity * _jump_height * 2) * -1
var _is_on_floor: bool
var _was_on_floor: bool
var is_jumping: bool = false

func _ready() -> void:
	_move_speed = _walk_speed

func face_left(left: bool = true) -> void:
	sprite_2d.flip_h = left

func walk() -> void:
	_move_speed = _walk_speed
	
func run() -> void:
	_move_speed = _run_speed

func jump() -> bool:
	if _is_on_floor or _coyote and not _coyote.is_stopped():
		velocity.y = _jump_force
		is_jumping = true
		return true
	return false
		
func cancel_jump() -> void:
	if velocity.y < 0:
		velocity.y /=2
	
func _ground_physics(delta) -> void:
	
	if direction:
		if velocity.x == 0 or sign(velocity.x) == sign(direction):
			velocity.x = move_toward(velocity.x, direction * _move_speed, _acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * _move_speed, _deceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)

func _air_physics(delta) -> void:
	velocity.y += _gravity * delta
	velocity.y = min(velocity.y, _terminal_velocity)
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * _move_speed, _acceleration * _air_control * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, _deceleration * _air_brakes * delta)
	
func _physics_process(delta: float) -> void:
	
	if direction < 0:
		face_left()
	elif direction > 0:
		face_left(false)
		
	_was_on_floor = _is_on_floor
	_is_on_floor = is_on_floor()
	
	if _was_on_floor and not _is_on_floor and velocity.y >= 0:
		_coyote.start()
	
	if _is_on_floor:
		_ground_physics(delta)
	else:
		_air_physics(delta)
	
	if is_jumping and velocity.y >= 0:
		is_jumping = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
		
	move_and_slide()
