extends Node

@export var numSlots = 4
@export var minSpawnTime = 7
@export var maxSpawnTime = 12

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
	printSlots()
	availableSlots = slots.size()
	_set_timer()
	
func createCustomer(slot):
	var newCustomer = customerScene.instantiate()
	add_child(newCustomer)
	newCustomer._set_slot(slot)
	newCustomer.destroyed.connect(_on_slot_cleared)
	slots[slot].is_used = true
		
func _on_slot_cleared(slot):
	print("Slot cleared" + str(slot))
	slots[slot].is_used = false
	
func getAvailableSlot():
	for i in range(slots.size()):
		if (not slots[i].is_used):
			return i
	availableSlots = 0
	return -1

func createSlots():
	for i in range(numSlots):
		var newSlot = Slot.new()
		newSlot.index = i + 1
		slots.append(newSlot)

func printSlots():
	for i in range(slots.size()):
		print(slots[i].index)


func _on_timer_timeout():
	if (availableSlots > 0):
		var slot = getAvailableSlot()
		print("Available slot: " + str(slot))
		createCustomer(slot)
		_set_timer()
		
func _set_timer():
	var spawnTime = randf_range(minSpawnTime, maxSpawnTime)
	print("Wait time: " + str(spawnTime))
	var timer = get_node("Timer")
	timer.start(spawnTime)
	
