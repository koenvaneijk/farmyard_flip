extends GridContainer

var matched_cards = []
var flipped_cards = []

var enabled = true

@export var width = 4
@export var height = 3

func shuffle_cards():
	# Shuffle the cards
	var children = get_children()
	var children_list = children.duplicate()
	
	children_list.shuffle()
	
	for child in children:
		remove_child(child)
	
	for child in children_list:
		add_child(child)
	
	for child in get_children():
		if child is Card:
			child.reset()
			
func new_game():
	for child in get_children():
		if child is Card:
			child.free()
	
	create_cards()
	shuffle_cards()

func handle_card_match(card1, card2):
	$MatchSound.play()
	
	card1.matched()
	card2.matched()
	
	matched_cards.append(card1)
	matched_cards.append(card2)
	
	flipped_cards.clear()
	

func handle_card_mismatch(card1, card2):
	$MismatchSound.play()		
	
	card1.mismatched()
	card2.mismatched()
	
	flipped_cards.clear()

func create_cards():
	var dir = DirAccess.open("res://Cards/")

	dir.list_dir_begin()
	var files = []
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".webp"):
			files.append(file)
	dir.list_dir_end()
		
	for i in range(files.size() - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = files[i]
		files[i] = files[j]
		files[j] = temp
		
	var CardScene = preload("res://Card.tscn")
	for i in range(width * height / 2):
		for _j in range(2): # Two cards for each pair
			var card = CardScene.instantiate()
			card.texture_normal = load("res://Cards/" + files[i])
			card.value = i
			add_child(card)
			card.connect("flipped", _on_card_flipped)
			
func _on_card_flipped(card):
	# Add flipped card to stack
	flipped_cards.append(card)

	# 2 cards flipped
	if flipped_cards.size() >= 2:
		enabled = false
		
		# Match
		if flipped_cards[0].value == flipped_cards[1].value:
			handle_card_match(flipped_cards[0], flipped_cards[1])
			enabled = true
			
		# Mismatch
		else:
			handle_card_mismatch(flipped_cards[0], flipped_cards[1])
			await get_tree().create_timer(2.0).timeout # waits for 2 seconds
			enabled = true
		
		# Game completed
		if len(matched_cards) >= (width * height): 
			$CheerSound.play()
		
		return


func _ready():
	new_game()

func _on_button_pressed():
	shuffle_cards()

func _on_button_2_pressed():
	new_game()
