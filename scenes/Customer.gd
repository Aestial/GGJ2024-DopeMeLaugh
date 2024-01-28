extends Node

signal destroyed
signal selected
signal solved

# Gameplay parameters
@export var min_pill_count = 0
@export var max_pill_count = 6
@export var min_wait_time = 3.0
@export var max_wait_time = 10.0
# UI parameters
@export var min_slot_width = 80
@export var max_slot_width = 250
@export var panel_speed = 10
# Sprites parameters
@export var character_origin = Vector2(320, 280)
@export var character_offset = Vector2(120, 0)
@export var character_sprites: Array[Texture2D]

var container
var is_selected = false
var is_solved = false
var recipe = {"S":5, "D":2, "F":4, "G":6}
var solution = {"S":0, "D":0, "F":0, "G":0}
var slot = -1
var slot_width
var timer
var waitTime

func set_slot(_slot):
	slot = _slot
	_set_character(slot)
	$Control/Slot.position = Vector2(0, slot * 80)
	$Control/Slot/ARContainer/Label.text = str(slot + 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Godot needed functions for random and input events
	randomize()
	set_process_input(true)
	container = $Node2D/Container
	# Customer recipe
	_randomize_recipe()	
	_print_recipe()
	# Customer timer
	slot_width = max_slot_width
	_show_details(false)
	timer = get_node("Timer")
	waitTime = randf_range(min_wait_time, max_wait_time)
	#print("Customer time: " + str(waitTime))
	timer.start(waitTime)
	
func _input(event):
	## Dismiss input when parent is busy with another customer
	if not is_selected and get_parent().is_busy:
		return
	## Get key events
	if event is InputEventKey and event.pressed:
		var code = event.keycode
		## Select this customer if slot key is pressed
		if not is_selected and code == 49 + slot:
			_select(true)
			return
		if is_selected:
			if code == KEY_ENTER:
				var distance = _get_recipe_distance()
				print("Recipe distance: " + str(distance))
				var score = 10 - distance
				container.close()
				$Control/Score.set_score(score)
				$Control/Slot.visible = false
				emit_signal("solved", slot, score)
				await get_tree().create_timer(0.5).timeout
				_show_details(false)
				await get_tree().create_timer(1.0).timeout
				queue_free()
			for key in recipe.keys():
				if event.keycode == OS.find_keycode_from_string(key):
					solution[key] += 1
					container.add_pill(key)

func _process(_delta):
	var percentage = timer.time_left / waitTime
	$Control/Slot.size.x = lerp(min_slot_width, max_slot_width, percentage)

func _on_wait_timer_timeout():
	queue_free()

func _on_tree_exited():
	emit_signal("destroyed", slot)

func _select(is_true):
	container.open()
	is_selected = is_true
	timer.stop()
	emit_signal("selected", slot)
	_show_details(is_selected)
	
func _get_recipe_distance():
	var distance = 0
	for key in recipe.keys():
		distance += abs(recipe[key] - solution[key])
	return distance

func _print_recipe():
	var message = ""
	for pill in recipe:
		var amount = recipe[pill]
		if (amount > 0):
			message += pill + ": " + str(amount) + "\n"
	$Control/Recipe/Label.text = message

func _randomize_recipe():
	for key in recipe.keys():
		var value = randi_range(min_pill_count, max_pill_count)
		recipe[key] = value

func _set_character(slot):
	var char_index = randi_range(0, character_sprites.size() - 1)
	var character = $Node2D/Character
	character.texture = character_sprites[char_index]
	character.position = character_origin + character_offset * slot

func _show_details(show):
	$Control/Recipe.visible = show
	container.visible = show
