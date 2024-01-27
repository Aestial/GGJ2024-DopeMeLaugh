extends Node

@export var minWaitTime = 3.0
@export var maxWaitTime = 10.0

signal destroyed

var slot = -1
var is_selected = false
var is_solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var waitTime = randf_range(minWaitTime, maxWaitTime)
	print("Customer time: " + str(waitTime))
	var timer = get_node("Timer")
	timer.start(waitTime)
	
func _set_slot(_slot):
	slot = _slot
	$Control/Slot.position = Vector2(0, slot * 80)
	var userSlot = slot + 1
	$Control/Slot/Label.text = str(userSlot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_wait_timer_timeout():
	queue_free()

func _on_tree_exited():
	emit_signal("destroyed", slot)
