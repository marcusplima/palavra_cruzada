extends Button

signal del_selected_word
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_pressed():
	del_selected_word.emit()

#manter botão apagado
#pintar botão se selecionar item
#apagar botão depois de apagar
