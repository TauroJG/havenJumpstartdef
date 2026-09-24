extends Area2D

const base_magnet_radius:= 90.0
const collect_radius:= 16.0
const speed:= 260.0

var xp_value:int=5
var target: Node2D= null
var bob_time:=0.0
var collect:= false
func _ready() -> void:
	body_entered.connect(_on_body_enered)
	var players:= get_tree().get_nodes_in_group("player")
	if players.size()>0:
		target= players[0]
		
func _process(delta:float) -> void:
	bob_time += delta
	position.y += sin(bob_time* 4.0)* 0.15
	
	if target!= null and is_instance_valid(target):
		var dist:= global_position.distance_to(target.global_position)
		var magnet_radius:= base_magnet_radius* GameManager.magnet_mult
		if dist <= magnet_radius:
			global_position= global_position.move_toward(target.global_position, speed*delta)
		of dist <= collect_radius:
			_collect()
func _on_body_entered(body:Node) ->void:
	if body.is_in_group("player"):
		_collect()
func _collect() -> void:
	if collected:
		return
	collected= true
	GameManager.add_xp(xp_value)
	queue_free()
	
