extends Button

signal add_new_word(word_text)

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_pressed():
	var LineEdit_word = get_node("%LineEdit_new_word").text
	if len(LineEdit_word) > 0:
		add_new_word.emit(LineEdit_word)
	get_node("%LineEdit_new_word").text = ""
	get_node("%LineEdit_new_word").grab_focus()
#pintar botão se lineedit tiver texto
#apagar botao se linedit em branco
#apagar line edit ao inserir linha
