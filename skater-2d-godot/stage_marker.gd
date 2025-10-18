extends Area2D

var slope = preload("res://stage_pieces/small_slope.tscn")


func _on_area_entered(area: Area2D) -> void:
	add_child(slope.instantiate())
