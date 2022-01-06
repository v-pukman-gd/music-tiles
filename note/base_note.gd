extends Node2D

export(int, 0, 3) var line
var pos = 600
var length = 400
var length_scale = 1

var width = 180
var height = 180

var collected = false
var rect_size = Vector2()

func _ready():
	_on_ready()

func _on_ready():	
	height = length*length_scale
	position = Vector2(width*line, pos*length_scale)
	
	rect_size = Vector2(width, height)
	$Control.rect_size = rect_size
	$Control.rect_position = Vector2(0, -rect_size.y)
	$Control/Rect.rect_size = rect_size
	
	print($Control.rect_size, "____", $Control.rect_position)
	
	$Control.connect("gui_input", self, "_on_control_gui_input")
		
func _on_control_gui_input(event):
	print(event)
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed and not collected:
			collected = true
			_on_collected()
	
func _process(delta):
	_on_process(delta)
	
func _on_process(delta):
	pass

func _on_rect_input(event):
	print(event)
	
func _on_collected():
	hide()
