extends Node2D

var bar_scn = preload("res://bar.tscn")
var bars = []
onready var bars_node = $BarsNode

var bar_length_in_m
var curr_location
var speed
var note_scale
#var surface_speed

var curr_bar_index
var tracks_data 

var game
var curr_line = 0

var bars_data = null

func setup(game):
	self.game = game
	
	speed = Vector2(0,game.speed)
	bar_length_in_m = game.bar_length_in_m
	curr_location = Vector2(0,0)
	note_scale = game.note_scale
	curr_bar_index = 0
	tracks_data = game.map.tracks
	#surface_speed = Vector3(-game.quarter_time_in_sec, 0, 0)
	add_bars()
#	apply_surface_speed()

	bars_node.position.y = -game.pre_start_duration_in_m-game.start_pos_in_px
	
		
func _process(delta):
	#if not game.game_started: return
	bars_node.translate(speed*delta)
	
	for bar in bars:		
		if bar.global_position.y - bar_length_in_m > OS.window_size.y:
			print("delete at", bar.global_position.y - bar_length_in_m)
			remove_bar(bar)
			add_bar()
		

func add_bar():
	if tracks_data.size() <= 0 or curr_bar_index >= tracks_data[3].bars.size(): return
	if not bars_data:
		prepare_bars_data(tracks_data[3])
	
	var bar = bar_scn.instance()
	bar.position = Vector2(curr_location.x, curr_location.y)
	bar.note_scale = note_scale
	bar.bar_data = bars_data[curr_bar_index] #get_bar_data()
	
	curr_line = bar.add_notes(curr_line)
	#bar.speed = speed
	bars.append(bar)
	bars_node.add_child(bar)
	curr_location -= Vector2(0,bar_length_in_m)
	curr_bar_index += 1
	
func prepare_bars_data(track_data):
	var plain_notes = []
	var bar_index = 0
	for bar in track_data.bars:
		for note in bar.notes:
			note.bar_index = bar_index
			note.global_pos = bar_index*1600 + int(note.pos)
			plain_notes.append(note)
		
		if not bars_data: bars_data = []
		bars_data.append({"index": bar_index, "notes": []})
		bar_index += 1
	

	var note_index = 0
	var extended_notes = []
	for note in plain_notes:
		var extended = note.markers.has("extended")
		if extended:
			extended_notes.append(note)
			note_index += 1
			continue
		else:
			if note_index+1 < plain_notes.size():
				var next = plain_notes[note_index+1]
				note.full_len = next.global_pos - note.global_pos
			else:
				note.full_len = max(400, int(note.len))
				
			if extended_notes.size() > 0:
				var extended_note = extended_notes[0]
				extended_note.full_len = note.global_pos - extended_note.global_pos + note.full_len
				note = extended_note
				extended_notes = []
		
		bars_data[note.bar_index].notes.append(note)
		note_index += 1
		
	bars_data
	#print(plain_notes)
	
#	for bar_index in track_data.bars.size():
#		var bar_data = track_data.bars[bar_index]
#		for note_index in bar_data.notes.size():
#			var note_data = bar_data.notes[note_index]
#
#			var full_length = int(note_data.len)
#			var pos = int(note_data.pos)
#
#			if  bar_data.notes.size() < note_index+1:
#				var next_note_data = bar_data.notes[note_index+1]
#				var d = int(next_note_data.pos) - pos
#				full_length = full_length
			
				
	
func get_bar_data():
	var left_data = tracks_data[0].bars[curr_bar_index]
	var center_data = tracks_data[1].bars[curr_bar_index]
	var right_data = tracks_data[2].bars[curr_bar_index]
	return [left_data, center_data, right_data]
	
func remove_bar(bar):
	bar.queue_free()
	bars.erase(bar)
	
func add_bars():
	for i in range(4):
		add_bar()
	
#func apply_surface_speed():
#	var mat = $RoadSurface/Plane.get_surface_material(0)
#	mat.set_shader_param("Speed", surface_speed)
