extends CharacterBody2D


#const SPEED = 100.0
const ACCELERATION = 5.0
const JUMP_VELOCITY = -200.0
@export var max_speed = 200.0

func _ready() -> void:
	floor_stop_on_slope = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	

	# Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction == 1.0:
		velocity.x += direction * ACCELERATION
	elif direction == -1.0:
		velocity.x -= ACCELERATION
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	velocity.x = clampf(velocity.x, 0, max_speed)
	move_and_slide()
	self.rotation = get_floor_angle()
