extends "res://note/base_note.gd"

func _on_process(delta):
	if pressed and not collected:
		collected = true
		_on_collected()


