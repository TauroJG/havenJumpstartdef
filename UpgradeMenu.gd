extends CanvasLayer


@onready var buttons: Array=[
	$Panel/VBoxContainer/Button,
	$Panel/VBoxContainer/Button2,
	$Panel/VBoxContainer/Button3,
]
var current_choices: Array= []
func _ready () -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible= false
	for i in buttons.size():
		buttons[i].pressed.connect(_on_option_pressed.bind(i))
		
func open_with_choices(choices: Array) -> void:
	current_choices= choices
	for i in buttons.size():
		if i< choices.size():
			buttons[i].visible= true
			buttons[i].text= "%s\n%s" % [choices[i]["name"], choices[i]["desc"]]
		else:
			buttons[i].visible=false
	visible= true
	get_tree().paused=true
func _on_option_pressed(i:int) -> void:
	if i < current_choices.size():
		GameManager.apply_upgrade(current_choices[i]["id"])
	visible= false
	get_tree().paused= false  
