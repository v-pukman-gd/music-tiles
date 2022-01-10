extends "res://note/base_note.gd"

var start_processing = false
var canceled = false

func _on_ready():
	._on_ready()
	$Control/Line.scale = Vector2((rect_size.y-100)/100, 2)
	$Control/Line.position.y = rect_size.y/2-18

func _on_process(delta):
	if pressed:
		if not collected and not canceled:
			start_processing = true
			$Control.rect_size -= speed*delta
			$Control/Rect.rect_size -= speed*delta
			
			$Control/Line.scale = Vector2(($Control/Rect.rect_size.y-100)/100, 2)
			$Control/Line.position -= speed*delta*0.5
			
			if $Control.rect_size.y <= 100:
				collected = true
				_on_collected()
			
	else:
		if start_processing and not canceled:
			canceled = true
			#_on_collected()
