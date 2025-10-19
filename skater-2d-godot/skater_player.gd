extends CharacterBody2D


#const SPEED = 100.0
var ACCELERATION = 50.0
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

var player_degree = 0
var ending_degree = 1.5*PI
var last_degree = 0

var flips = 0
var speed_boost = false

var speed_boost_timer: float = 0
var speed_boost_end: float = 2

var slowed = false
var delay_counter = 0
var delay_print = 0.5

# Constants
const SNAP_LENGTH = 4.0
const FLOOR_MAX_ANGLE = 45.0  # Max angle to consider a floor
var stored_boost = false
# Variables
var snap_vector: Vector2 = Vector2.DOWN * SNAP_LENGTH

@onready var timer: Timer = $Timer

@onready var cast: RayCast2D = $RayCast2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D



func _ready() -> void:
	floor_stop_on_slope = false
	floor_snap_length = 4

func _physics_process(delta: float) -> void:
	var is_grounded := is_on_floor()
	
	# Coyote time logic
	if is_grounded:
		if stored_boost:
			speed_boost = true
			sprite_2d.play("boosted")
			velocity.x += ACCELERATION
			stored_boost = false
		coyote_timer = COYOTE_TIME  # Reset when grounded
	else:
		coyote_timer -= delta  # Count down when not grounded
	
	var direction := Input.get_action_strength("go")
	if speed_boost:
		speed_boost_timer += delta
		
	if speed_boost_timer > speed_boost_end:
		speed_boost_timer = 0
		speed_boost = false
		sprite_2d.play("default")
	if not is_on_floor():
		#velocity.x = lerp(velocity.x, direction*AIR_SPEED, 0.1)
		var flip_d := Input.get_axis("backflip_p1", "frontflip_p1")
		if abs(flip_d) == 1:
			flipping = true
			SignalBus.status_update.emit("flipping")
		else:
			flipping = false
			
		rotation += flip_d * 0.1
		player_degree += rotation - last_degree
		if abs(player_degree) >= ending_degree:
			player_degree = 0
			flips += 1
			stored_boost = true
		if coyote_timer <= 0.0:
			velocity += get_gravity() * delta * 0.25
	
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)
	if slowed:
		ACCELERATION = 30
		delay_counter += delta
	if delay_counter > delay_print:
		slowed = false
		delay_counter = 0
		ACCELERATION = 50
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
		SignalBus.status_update.emit("none")

	# if surface_normal.x < 0 or surface_normal.y == 0:
	# 	floor_snap_length = 0
	if max_speed < 300:
		max_speed += delta/100
	# set max and min speed
	if self.position.x < SignalBus.camera_position.x - 200 or speed_boost:
		velocity.x = clampf(velocity.x, 10, max_speed + 100)
	else:
		velocity.x = clampf(velocity.x, 10, max_speed)
		ACCELERATION = 100
	if is_on_floor():
		rotation = rotate_toward(rotation, surface_normal.x, 0.5)
		ACCELERATION = 50

	move_and_slide()
	if self.position.x >= 10000 and SignalBus.winned == false:
		SignalBus.winned = true
		SignalBus.p1win.emit()
	last_degree = rotation
	# rotation = rotate_toward(rotation, get_floor_angle(), 0.5)

func _on_player_area_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		slowed = true
		velocity.x = 0
