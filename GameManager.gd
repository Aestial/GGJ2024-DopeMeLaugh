extends Node

@export var numSlots = 4
@export var minSpawnTime = 3	
@export var maxSpawnTime = 10

var customerScene = load("res://Customer.tscn")

class Slot:
	var index = 0
	var is_used = false
	var is_active = false
	
var slots = []
var availableSlots = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	createSlots()
	availableSlots = slots.size()
	
func createSlots():
	for i in range(numSlots):
		var newSlot = Slot.new()
		newSlot.index = i + 1
		slots.append(newSlot)

func _on_start_button_pressed():
	$Control.visible = false
	_set_timer()

func _on_timer_timeout():
	if (availableSlots > 0):
		var slot = getAvailableSlot()
		createCustomer(slot)
		_set_timer()
		
func _set_timer():
	var spawnTime = randf_range(minSpawnTime, maxSpawnTime)
	print("Spawn time: " + str(spawnTime))
	var timer = get_node("Timer")
	timer.start(spawnTime)
				
func createCustomer(slot):
	var newCustomer = customerScene.instantiate()
	newCustomer._set_slot(slot)
	newCustomer.destroyed.connect(_clear_slot)
	add_child(newCustomer)
	slots[slot].is_used = true

func _clear_slot(slot):
	slots[slot].is_used = false
	
func getAvailableSlot():
	for i in range(slots.size()):
		if (not slots[i].is_used):
			return i
	availableSlots = 0
	return -1
