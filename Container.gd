extends Sprite2D

@export var closed_container_sprite: Texture2D
@export var open_container_sprite: Texture2D
@export var pill_origin = Vector2(-90, 160)
@export var pill_offset = Vector2(50, -50)
@export var pill_grid_size = Vector2(5, 5)
@export var pill_textures: Array[Texture]

var num_pills = 0

func add_pill(type):
	var new_sprite = Sprite2D.new()
	new_sprite.show_behind_parent = true
	match type:
		"S":
			new_sprite.texture = pill_textures[0]
		"D":
			new_sprite.texture = pill_textures[1]
		"F":
			new_sprite.texture = pill_textures[2]
		"G":
			new_sprite.texture = pill_textures[3]
	var x = num_pills % int(pill_grid_size.x)
	var y = num_pills / int(pill_grid_size.y)
	var grid_position = Vector2(x, y)	
	new_sprite.position = pill_origin + grid_position * pill_offset
	add_child(new_sprite)
	num_pills += 1

func close():
	texture = closed_container_sprite

func open():
	texture = open_container_sprite
	
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = open_container_sprite
