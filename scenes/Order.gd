extends Control

var key
var text

func set_order(sprite, message):
	$Key.texture = sprite
	$Text.text = message
