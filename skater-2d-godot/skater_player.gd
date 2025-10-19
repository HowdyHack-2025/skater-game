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

@onready var cast: RayCast2D = $RayCast2D

func _ready() -> void:
	floor_stop_on_slope = false

func _physics_process(delta: float) -> void:
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
	if falling:
		velocity += get_gravity() * delta * 0.5
	
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)

	var surface_normal: Vector2

	if cast.is_colliding():
		surface_normal = cast.get_collision_normal()
		if surface_normal.x != 0:
			last_normal = surface_normal
	if direction == 1.0:
		SignalBus.status_update.emit("go")
	if direction == 1.0 or flipping:
		var tangent: Vector2 = Vector2(-surface_normal.y, surface_normal.x).normalized()
		velocity += tangent * direction * ACCELERATION * delta
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION/100)
	velocity.x = clampf(velocity.x, 10, max_speed)
	if is_on_floor():
		rotation = rotate_toward(rotation, surface_normal.x, 0.5)
	#print(surface_normal.x)
	if last_normal.x < 0 and surface_normal.x == 0:
		print("Just left slope")
		

	move_and_slide()
	# rotation = rotate_toward(rotation, get_floor_angle(), 0.5)

func _on_player_area_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		print("hit")
