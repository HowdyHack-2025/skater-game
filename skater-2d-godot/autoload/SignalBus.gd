extends Node

signal status_update(status: String)
signal status_update2(status: String)
signal behind(player: String)
signal p1win(win: String)
signal p2win(win: String)
var winned = false

var started = false

var camera_position: Vector2
@onready var progress: ProgressBar = get_tree().current_scene.find_child("ProgressBar")
@onready var camera: Camera2D = get_tree().current_scene.find_child("Camera2D")

func _process(delta: float) -> void:
	camera_position = camera.global_position
	progress.max_value = 10000
	progress.value = camera.position.x
