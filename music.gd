extends Node

onready var player = $AudioStreamPlayer
#onready var anim = $AnimationPlayer

var speed
var started
var pre_start_duration
var start_pos_in_sec

var game

func _ready():
	pass
	
func setup(game):
	self.game = game
	player.stream = game.audio
	player.stream.set_loop(false)
	
	speed = game.speed
	started = false
	pre_start_duration = game.pre_start_duration_in_m
	#start_pos_in_sec = game.start_pos_in_sec
	
func start():
	started = true
	#player.play(start_pos_in_sec)
	player.play(0)
	#anim.play("sound_on")
	
func _process(delta):
	#if not game.game_started: return
	if not started:
		pre_start_duration -= speed*delta
		if pre_start_duration <= 0:
			start()
			return

