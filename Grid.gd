extends GridContainer

var matched_cards = []
var flipped_cards = []

@export var width = 4
@export var height = 3

func shuffle():
	var children = get_children()
	var children_list = children.duplicate()
	children_list.shuffle()
	for child in children:
		remove_child(child)
	for child in children_list:
		add_child(child)
		
	for child in get_children():
		if child is TextureButton:
			child.reset()
		
	
func disable():
	for child in get_children():
		if child is TextureButton:
			child.disabled = true
		
func enable():
	for child in get_children():
		if child is TextureButton:
			child.disabled = false
			
			
func _on_card_flipped(card):
	print("Added!")
	flipped_cards.append(card)
	
	# Check if there are two cards flipped.
	if flipped_cards.size() >= 2:
		disable()
		
		# Check if the two cards match.
		if flipped_cards[0].value == flipped_cards[1].value:
			print("match!")
			# Handle the match - keep them face up, disable them, or remove them.
			#handle_match(flipped_cards[0], flipped_cards[1])
			flipped_cards[0].matched()
			flipped_cards[1].matched()
			
			flipped_cards.clear()
			$MatchSound.play()
		else:
			# If they don't match, flip them back after a delay.
			print("no match!")
			$MismatchSound.play()
			
			await get_tree().create_timer(2.0).timeout # waits for 2 seconds
			
			flipped_cards[0].flip()
			flipped_cards[1].flip()
			
			#delay_flip(flipped_cards[0], flipped_cards[1])
			flipped_cards.clear()
		
		enable()
			

			
	

# This assumes you have a method in the Card script to get the value for comparison.
func handle_match(card1, card2):
	print("match!")

# Use a timer to delay the flip back action.
func delay_flip(card1, card2):
	# Disable further input here if necessary.
	var timer = Timer.new()
	timer.wait_time = 1 # 1 second delay
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await(timer)
	card1.flip_back()
	card2.flip_back()

	
func _ready():
	connect("flipped", _on_card_flipped)
	
	for i in range((width*height/2)):
		print(i)
		var CardScene = load("res://Card.tscn")
		var card1 = CardScene.instantiate()
		card1.texture_normal = load("res://Cards/"+str(i)+".webp")
		card1.value = i
		add_child(card1)
		card1.connect("flipped", _on_card_flipped)
		var card2 = CardScene.instantiate()
		card2.texture_normal = load("res://Cards/"+str(i)+".webp")
		card2.value = i
		add_child(card2)
		card2.connect("flipped", _on_card_flipped)
		
	shuffle()

func _on_button_pressed():
	shuffle()
