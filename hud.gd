extends CanvasLayer


@onready var level_label: Label = $LevelLabel
@onready var lives_label: Label= $LivesLabel
@onready var xp_bar: ProgressBar= $XPBar
@onready var game_over_panel: Panel= $GameOverPanel
@onready var restart_button: Button= $GameOverPanel/VBoxContainer/RestartButton

func _ready() -> void:
	process_mode= Node.PROCESS_MODE_ALWAYS
	GameManager.xp_changed.connect(_on_xp_changed)
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.game_over.connect(_on_game_over)
	restart_button.pressed.connect(_on_restart_pressed)
	game_over_panel.visible = false
	_on_level_changed(GameManager.level)
	_on_xp_changed(GameManager.xp, GameManager.xp_to_next)
	_on_lives_changed(GameManager.lives)
	
func _on_xp_changed(xp: int, xp_to_next: int) ->void:
	xp_bar.max_value= xp_to_next
	xp_bar.value=xp
func _on_level_changed(level:int) -> void:
	level_label.text= "Level %d" % level
func _on_lives_changed(lives:int) -> void:
	lives_label.text="Lives: %d" %lives
func _on_game_over() -> void:
	game_over_panel.visible= true
func _on_restart_pressed() -> void:
	get_tree().paused= false
	get_tree().reload_current_scene()
