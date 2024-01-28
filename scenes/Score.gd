extends Control

@export var faces: Array[Texture]
@export var laughs: Array[AudioStream]

func set_score(score):
	var audio
	var text
	var texture
	match score:
		10, 9:
			audio = laughs[0]
			text = "You got an A!"
			texture = faces[0]
		8, 7, 6:
			audio = laughs[1]
			text = "You got a B."
			texture = faces[1]
		5, 4, 3:
			audio = laughs[2]
			text = "You got a C."
			texture = faces[2]
		_:
			audio = laughs[3]
			text = "You failed!"
			texture = faces[3]
			
	$AudioStreamPlayer.stream = audio
	$AudioStreamPlayer.play()
	$Label.text = text
	$TextureRect.texture = texture
	visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
