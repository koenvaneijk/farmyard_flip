extends TextureButton

@export var value = 0

var is_flipped = false
var is_matched = false

var front_texture

var back_texture = preload("res://Back.png")

signal flipped(card)
signal unflipped(card)

func _ready():
	front_texture = texture_normal
	reset()
	
func reset():
	is_flipped = false
	is_matched = false
	texture_normal = back_texture
	
func flip():
	if !is_flipped:
		print("Flipped!")
		texture_normal = front_texture
		emit_signal("flipped", self)
	else:
		print("unflipped!")
		texture_normal = back_texture
		emit_signal("unflipped", self)

	is_flipped = !is_flipped
	
	$FlipSound.play()
	
	
func matched():
	is_matched = true
	disabled = true
	

func _on_pressed():
	flip()
