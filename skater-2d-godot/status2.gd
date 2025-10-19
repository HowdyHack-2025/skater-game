extends Panel

var current_status: String = ""
@onready var label: Label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.status_update2.connect(update_status)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = current_status
	
func update_status(status: String):
	current_status = status