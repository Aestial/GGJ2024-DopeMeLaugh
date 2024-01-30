extends Node

@export var game_music_stream: AudioStream
@export var min_spawn_time = 3.0
@export var max_spawn_time = 10.0
@export var num_slots = 4
@export var score_prefix = "Score: "

var customer_scene = load("res://scenes/Inmate.tscn")

class Slot:
	var index = 0
	var is_used = false
	var is_active = false

var audio
var available_slots = 0
var credits_screen
var is_busy = false
var score: 
	set(value):
		score = value
		score_screen.get_node("TitleLabel").text = score_prefix + str(score)
var score_screen
var start_screen
var slots = []
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	audio = $AudioStreamPlayer
	credits_screen = $CreditsScreen
	score_screen = $ScoreScreen
	start_screen = $StartScreen
	randomize()
	_create_slots()
	score = 0
	_on_back_button_pressed()
	available_slots = slots.size()
	$Node2D.visible = false
	score_screen.visible = false
	timer = get_node("Timer")
	
func _on_start_button_pressed():
	audio.stream = game_music_stream
	audio.play()
	score_screen.visible = true
	start_screen.visible = false
	$Node2D.visible = true
	_set_timer(3)
	
func _on_credits_button_pressed():
	start_screen.visible = false
	credits_screen.visible = true
	
func _on_back_button_pressed():
	start_screen.visible = true
	credits_screen.visible = false

func _on_timer_timeout():
	if (available_slots > 0):
		var slot = _get_available_slot()
		_create_customer(slot)
		_set_timer()
	else:
		_set_timer(min_spawn_time)

func _create_slots():
	for i in range(num_slots):
		var newSlot = Slot.new()
		newSlot.index = i + 1
		slots.append(newSlot)

func _get_available_slot():
	for i in range(slots.size()):
		if (not slots[i].is_used):
			return i
	available_slots = 0
	return -1

func _create_customer(slot):
	available_slots -= 1
	slots[slot].is_used = true
	var new_customer = customer_scene.instantiate()
	new_customer.set_slot(slot)
	new_customer.destroyed.connect(_destroyed_handler)
	new_customer.lost.connect(_lost_handler)
	new_customer.selected.connect(_selected_handler)
	new_customer.solved.connect(_solved_handler)
	add_child(new_customer)

func _destroyed_handler(slot):
	available_slots += 1
	slots[slot].is_used = false
	
func _lost_handler(slot, lost_score):
	score += lost_score

func _selected_handler(slot):
	is_busy = true
	slots[slot].is_active = true	

func _solved_handler(slot, slot_score):
	is_busy = false
	score += slot_score
	slots[slot].is_active = false
	
func _set_timer(time = 0.0):
	var spawnTime = time
	if (time <= 0):
		spawnTime = randf_range(min_spawn_time, max_spawn_time)
	timer.start(spawnTime)
 
