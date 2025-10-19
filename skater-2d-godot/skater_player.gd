extends CharacterBody2D


#const SPEED = 100.0
const ACCELERATION = 50.0
const JUMP_VELOCITY = -200.0
const MAX_FALL_SPEED = 200.0
@export var max_speed = 150.0
const AIR_SPEED = 100.0
const GRAVITY_TIMEOUT = 1.0
var air_time: float = 0
var falling: bool = true
var last_normal: Vector2
var flipping: bool = false

const COYOTE_TIME = 0.1  # seconds
var coyote_timer: float = 0.0

# Constants
const SNAP_LENGTH = 4.0
const FLOOR_MAX_ANGLE = 45.0  # Max angle to consider a floor

# Variables
var snap_vector: Vector2 = Vector2.DOWN * SNAP_LENGTH

@onready var timer: Timer = $Timer

@onready var cast: RayCast2D = $RayCast2D

func _ready() -> void:
	floor_stop_on_slope = false

func _physics_process(delta: float) -> void:
	var is_grounded := is_on_floor()

	# Coyote time logic
	if is_grounded:
		coyote_timer = COYOTE_TIME  # Reset when grounded
	else:
		coyote_timer -= delta  # Count down when not grounded
	
	var direction := Input.get_action_strength("go")
	
	if not is_on_floor():
		#velocity.x = lerp(velocity.x, direction*AIR_SPEED, 0.1)
		var flip_d := Input.get_axis("backflip_p1", "frontflip_p1")
		if abs(flip_d) == 1:
			flipping = true
			SignalBus.status_update.emit("flipping")
		else:
			flipping = false
			SignalBus.status_update.emit("none")
		rotation += flip_d * 0.1
		if coyote_timer <= 0.0:
			velocity += get_gravity() * delta * 0.5
	
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
	
	# set max and min speed
	velocity.x = clampf(velocity.x, 10, max_speed)
	if is_on_floor():
		rotation = rotate_toward(rotation, surface_normal.x, 0.5)

	move_and_slide()
	# rotation = rotate_toward(rotation, get_floor_angle(), 0.5)

func _on_player_area_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		print("hit")

# extends CharacterBody2D

# const ACCELERATION = 50.0
# const MAX_FALL_SPEED = 200.0
# @export var max_speed = 150.0
# const AIR_SPEED = 100.0
# const GRAVITY = 500.0
# const FLOOR_MAX_ANGLE = 45.0  # Degrees


# var last_normal: Vector2 = Vector2.UP
# var last_tangent: Vector2 = Vector2.RIGHT
# var flipping: bool = false
# var left_slope := false

# @onready var cast: RayCast2D = $RayCast2D

# func _physics_process(delta: float) -> void:
# 	var direction := Input.get_action_strength("go")
# 	var is_grounded := is_on_floor()
	
# 	# Flip logic (just visual)
# 	if not is_grounded:
# 		var flip_d := Input.get_axis("backflip_p1", "frontflip_p1")
# 		if abs(flip_d) == 1:
# 			flipping = true
# 			SignalBus.status_update.emit("flipping")
# 		else:
# 			flipping = false
# 			SignalBus.status_update.emit("none")
# 		rotation += flip_d * 0.1
	
# 	# Gravity (always apply if not grounded or leaving slope)
# 	if not is_grounded or left_slope:
# 		velocity.y += GRAVITY * delta

# 	# Clamp fall speed
# 	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)

# 	# Detect slope normal via raycast
# 	var surface_normal = Vector2.UP
# 	if cast.is_colliding():
# 		surface_normal = cast.get_collision_normal()
# 		last_normal = surface_normal
# 	else:
# 		surface_normal = last_normal

# 	# Compute floor angle
# 	var floor_angle = rad_to_deg(acos(surface_normal.dot(Vector2.UP)))

# 	# Compute slope tangent
# 	var tangent: Vector2 = Vector2(-surface_normal.y, surface_normal.x).normalized()
# 	last_tangent = tangent

# 	# 🚀 CORE FIX: Launch off slope if going upward and slope is steep
# 	if is_grounded and velocity.y < -20 and floor_angle > FLOOR_MAX_ANGLE:
# 		left_slope = true
# 	else:
# 		left_slope = false

# 	# Movement
# 	if (direction == 1.0 or flipping) and is_grounded and not left_slope:
# 		velocity += tangent * direction * ACCELERATION * delta
# 		SignalBus.status_update.emit("go")
# 	else:
# 		velocity.x = move_toward(velocity.x, 0, ACCELERATION / 100)

# 	# Clamp X speed
# 	velocity.x = clampf(velocity.x, 10, max_speed)

# 	# Apply final motion
# 	move_and_slide()
