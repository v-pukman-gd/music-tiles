extends Node2D


#onready var music_node = $Music
#onready var road_node = $Road

var audio
var map
var audio_file = "res://songs/song1_tchaikovsky/audio.ogg"
var map_file = "res://songs/song1_tchaikovsky/map.mboy"

var tempo
var bar_length_in_m
var quarter_time_in_sec
var speed
var note_scale
var start_pos_in_sec

var data_ready = false
var game_started = false

onready var flow_node = $Flow
onready var music_node = $Music

func _ready():
	audio = load(audio_file)
	map = load_map()
	setup()
	
func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if not game_started and data_ready and event.pressed:
			game_started = true
			$StartLabel.hide()
	
func setup():
	tempo = int(map.tempo)
	bar_length_in_m = 1600 # Godot meters
	quarter_time_in_sec = 60/float(tempo) # 60/60 = 1, 60/85 = 0.71
	speed = bar_length_in_m/float(4*quarter_time_in_sec) # each bar has 4 quarters # 
	note_scale = bar_length_in_m/float(4*400)
	start_pos_in_sec = (float(map.start_pos)/400.0) * quarter_time_in_sec
	
	flow_node.setup(self)
	music_node.setup(self)
	
	data_ready = true
	
func load_map():
	var file = File.new()
	file.open(map_file, File.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse(content).get_result()
	
func _process(delta):
	if not game_started:
		return
		
	#print(delta)
	
