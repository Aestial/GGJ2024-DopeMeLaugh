extends TextureRect

@export var textures: Array[Texture]


# Called when the node enters the scene tree for the first time.
func _ready():
	var index = randi_range(0, textures.size() - 1)
	texture = textures[index]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
