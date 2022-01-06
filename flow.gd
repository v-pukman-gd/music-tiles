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
	if tracks_data.size() <= 0 or curr_bar_index >= tracks_data[0].bars.size(): return
	var bar = bar_scn.instance()
	bar.position = Vector2(curr_location.x, curr_location.y)
	bar.note_scale = note_scale
	bar.bar_data = tracks_data[3].bars[curr_bar_index] #get_bar_data()
	
	curr_line = bar.add_notes(curr_line)
	#bar.speed = speed
	bars.append(bar)
	bars_node.add_child(bar)
	curr_location -= Vector2(0,bar_length_in_m)
	curr_bar_index += 1

	
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
