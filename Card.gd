class_name Card
extends TextureButton

@export var value = 0

var is_flipped = false
var is_matched = false

var front_texture
var back_texture = preload("res://Back.png")

signal flipped(card)

func _ready():
	front_texture = texture_normal
	reset()
	
func reset():
	is_flipped = false
	is_matched = false
	texture_normal = back_texture
	disabled = false
	
func flip():
	is_flipped = true
	texture_normal = front_texture
	emit_signal("flipped", self)
	$FlipSound.play()
	
func matched():
	is_matched = true
	disabled = true

func mismatched():
	await get_tree().create_timer(2.0).timeout # waits for 2 seconds
	reset()

func _on_pressed():
	if !is_matched and !is_flipped and get_parent().enabled:
		flip()
