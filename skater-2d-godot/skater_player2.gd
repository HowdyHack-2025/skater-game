extends CharacterBody2D


#const SPEED = 100.0
const ACCELERATION = 50.0
const JUMP_VELOCITY = -200.0
const MAX_FALL_SPEED = 200.0
@export var max_speed: float = 150.0
const AIR_SPEED = 100.0
const GRAVITY_TIMEOUT = 1.0
var air_time: float = 0
var falling: bool = true
var last_normal: Vector2
var flipping: bool = false

const COYOTE_TIME = 0.2  # seconds
var coyote_timer: float = 0.0

var beginning_degree
var player_degree = 0
var ending_degree = 1.5*PI
var last_degree = 0

var flips = 0

var delay_counter = 0
var delay_print = 0.1

# Constants
const SNAP_LENGTH = 4.0
const FLOOR_MAX_ANGLE = 45.0  # Max angle to consider a floor

# Variables
var snap_vector: Vector2 = Vector2.DOWN * SNAP_LENGTH

@onready var timer: Timer = $Timer

@onready var cast: RayCast2D = $RayCast2D

func _ready() -> void:
	floor_stop_on_slope = false
	floor_snap_length = 4

func _physics_process(delta: float) -> void:
	var is_grounded := is_on_floor()
	
	# Coyote time logic
	if is_grounded:
		coyote_timer = COYOTE_TIME  # Reset when grounded
	else:
		coyote_timer -= delta  # Count down when not grounded
	
	var direction := Input.get_action_strength("go_2")

	if delay_counter < 1:
		delay_counter += delta
	else:
		print(velocity)
		delay_counter = 0
	
	if not is_on_floor():
		#velocity.x = lerp(velocity.x, direction*AIR_SPEED, 0.1)
		var flip_d := Input.get_axis("backflip_p2", "frontflip_p2")
		if abs(flip_d) == 1:
			flipping = true
			SignalBus.status_update.emit("flipping")
		else:
			flipping = false
			SignalBus.status_update.emit("none")
		rotation += flip_d * 0.1
		player_degree += rotation - last_degree
		if abs(player_degree) >= ending_degree:
			player_degree = 0
			flips += 1
			print("flip")
		if coyote_timer <= 0.0:
			velocity += get_gravity() * delta * 0.25
	
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)

	var surface_normal: Vector2
	if cast.is_colliding():
		surface_normal = cast.get_collision_normal()
		if surface_normal.x != 0:
			last_normal = surface_normal
	if direction == 1.0:
		SignalBus.status_update.emit("go")
	if direction == 1.0 or flipping and is_on_floor():
		var tangent: Vector2 = Vector2(-surface_normal.y, surface_normal.x).normalized()
		velocity += tangent * direction * ACCELERATION * delta
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION/100)

	# if surface_normal.x < 0 or surface_normal.y == 0:
	# 	floor_snap_length = 0

	# set max and min speed
	velocity.x = clampf(velocity.x, 10, max_speed)
	if is_on_floor():
		rotation = rotate_toward(rotation, surface_normal.x, 0.5)

	move_and_slide()
	last_degree = rotation
	# rotation = rotate_toward(rotation, get_floor_angle(), 0.5)

func _on_player_area_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		print("hit")