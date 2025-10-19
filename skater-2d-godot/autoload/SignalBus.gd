extends Node

signal status_update(status: String)
signal status_update2(status: String)
signal p1win
signal p2win
var winned = false
var in_s = false
var camera_position: Vector2
@onready var progress: ProgressBar
@onready var camera: Camera2D

func _process(delta: float) -> void:
	if get_tree().current_scene.name == "World2D":
		in_s = true
		camera = get_tree().current_scene.find_child("Camera2D")
		progress = get_tree().current_scene.find_child("ProgressBar")
	if in_s:
		camera_position = camera.global_position
		progress.max_value = 10000
		progress.value = camera.position.x
