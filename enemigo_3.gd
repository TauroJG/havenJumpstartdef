extends CharacterBody2D


const XPOrbScene:= preload("res://xp_orb.tscn")
const Gravity:= 1100.0
const max_fall_speed:= 900.0
const xp_per_hit:=5
	
@export var hits_to_kill: int=3
var health: int
var move_speed: float= 60.0
var direction: int=1

@onready var visual: AnimatedSprite2D=$Visual
func _ready() -> void:
	health= hits_to_kill
	direction= 1 if randi() %2==0 else -1
	visual.play()
func _physics_process(delta: float) -> void:
	velocity.y= min(velocity.y+ Gravity*delta, max_fall_speed)
	velocity.x= direction* move_speed
	move_and_slide()
	if is_on_wall():
		direction *= -1
	visual.flip_h= direction < 0
func take_hit(amount: int) -> void:
	health -= amount
	if health <=0:
		die()
	else:
		_bump()
func _bump()-> void:
	scale= Vector2(1.15, 1.15)
	var tw:= create_tween()
	tw.tween_property(self, "scale", Vector2.ONE, 0.12)
	
func die() -> void:
	var orb := XPOrbScene.instantiate()
	orb.global_position= global_position
	orb.xp_value=hits_to_kill* xp_per_hit
	get_parent().add_child(orb)
	queue_free()
