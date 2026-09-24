extends Node2D


const EnemyScene := preload("res://enemigo.tscn")
const Enemy2Scene := preload("res://enemigo_2.tscn")
const Enemy3Scene := preload("res://enemigo_3.tscn")

@onready var upgrade_menu= $UpgradeMenu
@onready var spawn_timer: Timer=$SpawnTimer

var ground_left := 60.0
var ground_right:= 900.0
var spawn_y:= 440.0
var spawning:= true

func _ready() -> void:
	GameManager.reset_game()
	GameManager.level_up.connect(_on_leveled_up)
	GameManager.game_over.connect(_on_game_over)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	for i in 3:
		_spawn_enemy()
func _on_spawn_timer_timeout() -> void:
	print("timeout del spawn_timer disparado")   # ← agrega a esta línea
	if not spawning:
		return
	var max_enemies: int=clampi(3+ GameManager.level, 3, 10)
	print("enemigos vivos: ", get_tree().get_nodes_in_group("enemies").size(), " | máximo: ", max_enemies)   # ← y esta
	if get_tree().get_nodes_in_group("enemies").size() < max_enemies:
		_spawn_enemy()
	spawn_timer.wait_time= clampf(2.4- GameManager.level * 0.1,0.9, 2.4)
func _spawn_enemy() -> void:
	var hits := _pick_hits()
	var scene: PackedScene
	match hits:
		1: scene = EnemyScene
		2: scene= Enemy2Scene
		_: scene= Enemy3Scene
	var enemy := scene.instantiate()
	enemy.position= Vector2(randf_range(ground_left, ground_right), spawn_y)
	add_child(enemy)
	print("enemigo spawneado en: ", enemy.global_position)
func _pick_hits() -> int:
	var roll:= randf()
	var lvl:= GameManager.level
	if lvl >=5 and roll < 0.25:
		return 3
	elif lvl >=2 and roll <0.55:
		return 2
	return 1

func _on_leveled_up() -> void:
	upgrade_menu.open_with_choices(GameManager.get_random_upgrades(3))
func _on_game_over() -> void:
		spawning=false
		spawn_timer.stop()
	
