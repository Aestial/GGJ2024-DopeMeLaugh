extends Panel

@export var drug_names: Array[String]
@export var key_sprites: Array[Texture2D]

var order_scene = load("res://scenes/Drug.tscn")
var type_index = {"S":0, "D":1, "F":2, "G":3}

func print(rx):
	for pill in rx:
		var amount = rx[pill]
		if (amount > 0):
			_add_order(pill, amount)

func _add_order(type, count):
	var index = type_index[type]
	var drug = drug_names[index]
	var message = drug.substr(1) + ": " + str(count)
	var sprite = key_sprites[index]
	var new_order = order_scene.instantiate()
	new_order.set_order(sprite, message)
	$VBoxContainer.add_child(new_order)
