extends Node

var current_scene = null

func _deferred_goto_scene(path):
	if current_scene != null:
		current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	return
func goto_scene(path):
	_deferred_goto_scene.call_deferred(path)


func _deferred_addto_scene(path):
	
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	var new_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(new_scene)
	return
func addto_scene(path):
	_deferred_addto_scene.call_deferred(path)
	
