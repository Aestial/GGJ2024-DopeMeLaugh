extends Node

@export var minWaitTime = 3.0
@export var maxWaitTime = 10.0

signal destroyed
signal selected

var is_selected = false
var is_solved = false
var slot = -1
var timer

func set_slot(_slot):
	slot = _slot
	$Control/Slot.position = Vector2(0, slot * 80)
	$Control/Slot/Label.text = str(slot + 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	var waitTime = randf_range(minWaitTime, maxWaitTime)
	print("Customer time: " + str(waitTime))
	timer = get_node("Timer")
	timer.start(waitTime)
	
func _input(event):
	## Dismiss input when parent is busy with another customer
	if get_parent().is_busy and not is_selected:
		return
	## Get key events
	if event is InputEventKey and event.pressed:
		## Select this customer if slot key is pressed
		if not is_selected and event.keycode == 49 + slot:
			_select(true)
		if is_selected:
			match event.keycode:
				KEY_S:
					print("Pressed S")
				KEY_D:
					print("Pressed D")
				KEY_F:
					print("Pressed F")
			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_wait_timer_timeout():
	queue_free()

func _on_tree_exited():
	emit_signal("destroyed", slot)

func _select(selected):
	is_selected = selected
	timer.stop()
	emit_signal("selected", slot)
	$Control/Panel.visible = is_selected
	$Control/TextureRect.visible = is_selected
			
