extends Node

var gui = "uid://b82ppyqjrmxkp"

#func _ready() -> void:
	#SceneManager.addto_scene(gui)

const STAGE_PIECES: Dictionary[String, String] = {
	"small_v":"res://stage_pieces/small_slope.tscn",
	"ramp_down_heavy": "res://stage_pieces/ramp_down_heavy.tscn",
	"U45":"res://stage_pieces/U/u_45.tscn",
	"H1": "res://stage_pieces/H/h_1.tscn",
	"H2":"res://stage_pieces/H/h_2.tscn",
	"H3":"res://stage_pieces/U/u_3.tscn",
	"H4": "res://stage_pieces/U/u_4.tscn"
	#"H45":"res://stage_pieces/H/h_45.tscn"
}
