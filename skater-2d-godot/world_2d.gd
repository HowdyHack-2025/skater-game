extends Node2D

var slope: StaticBody2D
var previous_piece_end_pos = Vector2(72, 12)
@onready var stage_marker: Area2D = $StageMarker


func _on_area_entered(area: Area2D) -> void:
	print("ENTERED")
	var current_instance = ResourceLoader.load(Constants.STAGE_PIECES.values().pick_random()).instantiate()
	
	current_instance.position = previous_piece_end_pos
	previous_piece_end_pos = current_instance.get_node("EndMarker").global_position
	stage_marker.position = current_instance.get_node("EndMarker").global_position
	
	
	add_child.call_deferred(current_instance)
