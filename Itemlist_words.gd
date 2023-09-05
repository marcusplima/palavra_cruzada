extends ItemList

var i=0

# Called when the node enters the scene tree for the first time.
func _ready():
	var button_node = get_node("%Button_add_word")
	button_node.add_new_word.connect(add_word)
	
	button_node = get_node("%Button_del_word")
	button_node.del_selected_word.connect(delete_selected_word)
	var file_name = "user://word.txt"
	for words in load_file(file_name).split("\n"):
		if len(words) > 0:
			add_item(words.to_upper())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_word(word):
	add_item(word.to_upper())
	var words = ""
	for word_index in range(item_count):
		words = words + (get_item_text(word_index)) + "\n"
	var file_name = "user://word.txt"
	save(words, file_name)
	select(item_count -1)
	item_selected.emit(item_count -1)

func delete_selected_word():
	if len(get_selected_items()) > 0:
		remove_item(get_selected_items()[0])
	var words = ""
	for word_index in range(item_count):
		words = words + (get_item_text(word_index)) + "\n"
	var file_name = "user://word.txt"
	save(words, file_name)

func load_file(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	if file == null:
		file = FileAccess.open(file_name, FileAccess.WRITE)

	var content = file.get_as_text()
	return content

func save(content, file_name):
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(content)
