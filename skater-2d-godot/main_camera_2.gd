extends Camera2D

@onready var player = get_tree().current_scene.find_child("SkaterPlayer")
@onready var player2 = get_tree().current_scene.find_child("SkaterPlayer2")

var p1 = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if max(player.position.x, player2.position.x) == player.position.x:
		p1 = true
	else:
		p1 = false
	if p1:
		position = player.position
	else:
		position = player2.position
