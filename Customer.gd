extends Node

@export var slot = -1
@export var waitTime = 3.0

signal destroyed

var is_selected = false
var is_solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Wait time: " + str(waitTime))
	var timer = get_node("WaitTimer")
	timer.start(waitTime)
	
func _set_slot(slot):
	slot = slot
	$Control/Slot.position = Vector2(0, slot * 80)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_wait_timer_timeout():
	print("Timer finish")
	queue_free()

func _on_tree_exited():
	print("Destroying")
	emit_signal("destroyed", slot)
