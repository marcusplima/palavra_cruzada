extends Node2D

var new_letter
signal find_word (word_text)

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.request_permissions()
	add_letters()
	$TextEdit_letters.text = load_file("user://letters.txt")
	add_letters()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_text_edit_letters_text_changed():
	save($TextEdit_letters.text, "user://letters.txt")
	for node_ in get_children():
		if node_.name.begins_with("Label_letter_"):
			node_.queue_free()
	add_letters()
	
func add_letters():
	var letters_string = get_node("TextEdit_letters").text
	var letters_qty = len(letters_string)
	var line = 0
	var column = 0
	
	for i in range(letters_qty):
		if letters_string[i] == "\n":
			line += 1
			column = 0
		else:
			new_letter = get_node("Label_letter").duplicate()
			add_child(new_letter)
			new_letter.name = "Label_letter_" + str(i)
			new_letter.text = letters_string[i].to_upper()
			new_letter.pos_x = column
			new_letter.pos_y = line
			new_letter.set_unique_name_in_owner(true)
			new_letter.add_to_group('labels_group')
			
			get_children()[-1].position.x = (column * 26) + 30
			get_children()[-1].position.y = (line * 26) + 200
			column += 1


func _on_itemlist_words_item_selected(index):
	if not $CheckButton_lines_on.button_pressed:
		delete_lines()
	var word = get_node("Itemlist_words").get_item_text(index)
	apply_icon('XIcon')
	var labels = get_tree().get_nodes_in_group("labels_group")
	var found = false
	for letter_label in labels:
		letter_label.found = 0
	find_word.emit(word)
	for letter_label in labels:
		if letter_label.found != 0:
			found = true
	if not found:
		$not_found_sound.play()
	
func delete_lines():
	for node_ in get_children():
		if node_.name.begins_with("word_line_"):
			node_.queue_free()

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_file(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	if file == null:
		file = FileAccess.open(file_name, FileAccess.WRITE)
	var content = file.get_as_text()
	return content

func save(content, file_name):
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(content)

func apply_icon(icon):
	#var image = Image.load_from_file(icon_path)
	#var texture = ImageTexture.create_from_image(image)
	var texture = get_node(icon).texture
	var selected_item = get_node('Itemlist_words').get_selected_items()[0]
	get_node('Itemlist_words').set_item_icon(selected_item, texture)
