extends Node

@export var num_slots = 4
@export var min_spawn_time = 3	
@export var max_spawn_time = 10
@export var score_prefix = "Score: "

var customer_scene = load("res://Customer.tscn")

class Slot:
	var index = 0
	var is_used = false
	var is_active = false
	
var available_slots = 0
var is_busy = false
var score = 0
var slots = []
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_create_slots()
	_print_score()
	
	available_slots = slots.size()
	$Score.visible = false
	timer = get_node("Timer")
	
func _on_start_button_pressed():
	$StartMenu.visible = false
	$Score.visible = true
	_set_timer(3.5)

func _on_timer_timeout():
	if (available_slots > 0):
		var slot = _get_available_slot()
		_create_customer(slot)
		_set_timer()
	else:
		_set_timer(min_spawn_time)
	
						
func _create_customer(slot):
	available_slots -= 1
	slots[slot].is_used = true
	var new_customer = customer_scene.instantiate()
	new_customer.set_slot(slot)
	new_customer.destroyed.connect(_clear_slot)
	new_customer.selected.connect(_use_slot)
	new_customer.solved.connect(_solved_slot)
	add_child(new_customer)

func _clear_slot(slot):
	available_slots += 1
	slots[slot].is_used = false

func _create_slots():
	for i in range(num_slots):
		var newSlot = Slot.new()
		newSlot.index = i + 1
		slots.append(newSlot)

func _solved_slot(slot, distance):
	is_busy = false
	slots[slot].is_active = false
	slots[slot].is_used = false
	var slot_score = 10 - distance
	score += slot_score
	_print_score()

func _use_slot(slot):
	is_busy = true
	slots[slot].is_active = true	

func _get_available_slot():
	for i in range(slots.size()):
		if (not slots[i].is_used):
			return i
	available_slots = 0
	return -1

func _set_timer(time = 0.0):
	var spawnTime = time
	if (time <= 0):
		spawnTime = randf_range(min_spawn_time, max_spawn_time)
	timer.start(spawnTime)
	#print("Spawn time: " + str(spawnTime))

func _print_score():
	$Score/TitleLabel.text = score_prefix + str(score)
