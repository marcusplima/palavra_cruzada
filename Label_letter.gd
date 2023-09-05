extends Label

var pos_x = 0
var pos_y = 0
var directions = ['right', 'up_right', 'up', 'up_left', 'left', 'down_left', 'down', 'down_right']
var line_index = 0
var found = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_node = get_parent()
	main_node.find_word.connect(find_first_letter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func find_first_letter(word_text):
	if (name.begins_with("Label_letter_")) and (word_text.begins_with(text)):
		for direction in directions:
			var check_next_position = get_direction(pos_x, pos_y, direction)
			get_tree().call_group('labels_group',
									'_on_find_next_letter',
									word_text.substr(1,len(word_text)),
									check_next_position[0], 
									check_next_position[1], 
									direction, self)

func _on_find_next_letter(word_text, pos_x_check, pos_y_check, direction, node_ini):
	if pos_x == pos_x_check and pos_y == pos_y_check:
		if (name.begins_with("Label_letter_")) and (word_text.begins_with(text)):
			if len(word_text) == 1:
				trace_new_line(node_ini.get_node("Marker2D").global_position, 
								get_node("Marker2D").global_position)
				apply_icon('CheckIcon')
				get_parent().get_node('check_sound').play()
				found = 1
			else:
				var check_next_position = get_direction(pos_x_check, pos_y_check, direction)
				get_tree().call_group('labels_group',
									'_on_find_next_letter',
									word_text.substr(1,len(word_text)), 
									check_next_position[0], 
									check_next_position[1], 
									direction, node_ini)

func get_direction(pos_x_dir, pos_y_dir, direction):
	match(direction):
		"right":
			return Vector2(pos_x_dir + 1, pos_y_dir)
		"up_right":
			return Vector2(pos_x_dir + 1, pos_y_dir - 1)
		"up":
			return Vector2(pos_x_dir, pos_y_dir - 1)
		"up_left":
			return Vector2(pos_x_dir - 1, pos_y_dir - 1)
		"left":
			return Vector2(pos_x_dir - 1, pos_y_dir)
		"down_left":
			return Vector2(pos_x_dir - 1, pos_y_dir + 1)
		"down":
			return Vector2(pos_x_dir, pos_y_dir + 1)
		"down_right":
			return Vector2(pos_x_dir + 1, pos_y_dir + 1)

func trace_new_line(start_point, end_point):
	var new_line = get_parent().get_node("Line2D").duplicate()
	get_parent().add_child(new_line)
	new_line.name = 'word_line_' + str(get_parent().get_child_count())
	new_line.add_point(start_point)
	new_line.add_point(end_point)

func apply_icon(icon):
	#var image = Image.load_from_file(icon_path)
	#var texture = ImageTexture.create_from_image(image)
	var texture = get_parent().get_node(icon).texture
	var selected_item = get_parent().get_node('Itemlist_words').get_selected_items()[0]
	get_parent().get_node('Itemlist_words').set_item_icon(selected_item, texture)
