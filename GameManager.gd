extends Node

@export var numSlots = 4
@export var minSpawnTime = 3	
@export var maxSpawnTime = 10

var customerScene = load("res://Customer.tscn")

class Slot:
	var index = 0
	var is_used = false
	var is_active = false
	
var available_slots = 0
var is_busy = false
var slots = []
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	timer = get_node("Timer")
	
	_create_slots()
	available_slots = slots.size()
	
func _on_start_button_pressed():
	$Control.visible = false
	_set_timer(3.5)

func _on_timer_timeout():
	if (available_slots > 0):
		var slot = _get_available_slot()
		_create_customer(slot)
		_set_timer()
	else:
		_set_timer(minSpawnTime)
	
						
func _create_customer(slot):
	available_slots -= 1
	slots[slot].is_used = true
	var newCustomer = customerScene.instantiate()
	newCustomer.set_slot(slot)
	newCustomer.destroyed.connect(_clear_slot)
	newCustomer.selected.connect(_use_slot)
	add_child(newCustomer)

func _clear_slot(slot):
	available_slots += 1
	slots[slot].is_used = false

func _create_slots():
	for i in range(numSlots):
		var newSlot = Slot.new()
		newSlot.index = i + 1
		slots.append(newSlot)

func _use_slot(slot):
	is_busy = true
	slots[slot].is_active = true	

func _get_available_slot():
	for i in range(slots.size()):
		if (not slots[i].is_used):
			return i
	available_slots = 0
	return -1

func _set_timer(time = 0):
	var spawnTime = time
	if (time <= 0):
		spawnTime = randf_range(minSpawnTime, maxSpawnTime)
	timer.start(spawnTime)
	print("Spawn time: " + str(spawnTime))		
