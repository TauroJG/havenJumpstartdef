extends Node 

signal xp_changed(xp: int, xp_to_next: int)
signal level_changed(level: int)
signal lives_changed(lives: int)
signal level_up()
signal game_over()

var xp:int=0
var level: int=1
var xp_to_next: int=12
var lives: int=3
var max_lives: int=3

var speed_mult: float=1.0
var jump_mult: float= 1.0
var magnet_mult: float= 1.0
var stomp_bonus: int=0

var upgrade_catalog:= [
	{"id": "speed", "name": "fast legs", "desc": "+155 movement speed"},
	{"id": "jump", "name": "spring", "desc": "+15% jump and rebound height"},
	{"id": "magnet", "name": "xp magnet", "desc": "+40% XP collection radius"},
	{"id": "stomp", "name": "stomp", "desc": "Each jump deals 1 extra hit to enemies."},
	{"id": "life", "name": "life", "desc": "+1 Max HP and heals 1 HP."}
]
func _setup_input_activations() -> void:
	_add_action("move_left", [KEY_A, KEY_LEFT])
	_add_action("move_right", [KEY_D, KEY_RIGHT])
	_add_action("jump", [KEY_SPACE, KEY_W, KEY_UP])
func _add_action(action_name: String, keys: Array) -> void:
	if InputMap.has_action(action_name):
		return
	InputMap.add_action(action_name)
	for k in keys:
		var ev:= InputEventKey.new()
		ev.physical_keycode= k
		InputMap.action_add_event(action_name, ev)
func reset_game() -> void:
	xp=0
	level=1
	xp_to_next=12
	lives=3
	max_lives=3
	speed_mult=1.0
	jump_mult=1.0
	magnet_mult=1.0
	stomp_bonus=0
	xp_changed.emit(xp, xp_to_next)
	level_changed.emit(level)
	lives_changed.emit(lives)
func add_xp(ammount:int) -> void:
	xp += ammount
	while xp>= xp_to_next:
		xp -= xp_to_next
		level +=1
		xp_to_next= int(round(xp_to_next*1.25+5))
		level_changed.emit(level)
		level_up.emit()
	xp_changed.emit(xp, xp_to_next)
func lose_life() -> void:
	lives -=1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over.emit()
func get_random_upgrades(n: int=3)-> Array:
	var pool:= upgrade_catalog. duplicate()
	pool.shuffle()
	return pool.slice(0, min(n, pool.size()))
	
func apply_upgrade(id: String) -> void:
	match id:
		"speed":
			speed_mult*=1.15
		"jump":
			jump_mult*=1.15
		"magnet":
			magnet_mult *=1.4
		"stomp":
			stomp_bonus +=1
		"life":
			max_lives +=1
			lives= min(lives+1, max_lives)
			lives_changed.emit(lives)	
	
