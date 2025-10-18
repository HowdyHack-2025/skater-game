extends Node2D

var slope = preload("res://stage_pieces/small_slope.tscn")
var current_piece_end_pos = Vector2(0, 0)

func _on_area_entered(area: Area2D) -> void:
	print("ENTERED")
	var instance = slope.instantiate()
	instance.position = get_global_mouse_position()
	add_child(instance)
