extends Node2D


var short_note_scn = preload("res://note/short_note.tscn")
#var long_note_scn = preload("res://note/long_note.tscn")

var note_scale
var bar_data 

#var speed

var notes = []
var is_ready = false

func _ready():
	#add_notes()
	if not is_ready:
		for note in notes:
			add_child(note)
		is_ready = true

func add_notes(curr_line):
#	var line = 0
#	for line_data in bar_data:
#		var notes_data = line_data.notes
#		for note_data in notes_data:
#			add_note(line, note_data)
#		line += 1 
	
	var notes_data = bar_data.notes
	for note_data in notes_data:
		add_note(curr_line, note_data)
		var next_line = curr_line
		var small_diff = note_data.len <= 100
		while next_line == curr_line or (small_diff and abs(next_line-curr_line) > 1):
			next_line = rand_line()
		curr_line = next_line
			
	return curr_line

func rand_line():
	randomize()
	return randi()%4
		
func add_note(line, data):
	var note_scn = short_note_scn
	#if int(data.len) >= 400:
	#	note_scn = long_note_scn
	#else:
	#	note_scn = short_note_scn
		
	var note = note_scn.instance()
	note.line = line # 0 1 2 3
	note.pos = -int(data.pos)
	note.length = int(data.full_len)
	note.length_scale = note_scale
	#note.speed = speed
	#add_child(note)
	notes.append(note)
