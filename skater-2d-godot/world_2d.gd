extends Node2D

@onready var beginning: Node2D = $Beginning

var slope: StaticBody2D
@onready var previous_piece_end_pos = beginning.get_node("EndMarker").global_position
@onready var stage_marker: Area2D = $StageMarker
@onready var menu: ColorRect = %ColorRect
@onready var win: ColorRect = %WinScreen

func _ready() -> void:
	SignalBus.p1win.connect(winned)
	SignalBus.p2win.connect(winned)

func _on_area_entered(area: Area2D) -> void:
	print("hi")
	var current_instance = ResourceLoader.load(Constants.STAGE_PIECES.values().pick_random()).instantiate()
	
	current_instance.position = previous_piece_end_pos
	previous_piece_end_pos = current_instance.get_node("EndMarker").global_position
	stage_marker.position = current_instance.get_node("EndMarker").global_position
	
	add_child.call_deferred(current_instance)

func winned(winner: String):
	win.visible = true
	win.find_child("Winllabel").text = winner+ " WINS"

func _on_button_pressed() -> void:
	SignalBus.started = true
	menu.visible = false


# func _on_button_win_pressed() -> void:
# 	get_tree().reload_current_scene()
