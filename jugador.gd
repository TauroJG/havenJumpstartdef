extends CharacterBody2D#el jugador se mueve, salta y mata enemigos saltando sobre ellos


const base_speed:=220.0
const base_jump_velocity:=-420.0
const base_stomp_bounce:= -380.0
const gravity:= 1100.0
const max_fall_speed:= 900.0
const invincible_time:= 1.0
const knockback_x:= 220.0
const knockback_Y:= -260.0
var invincible:= false
var invincible_timer:= 0.0

@onready var visual: AnimatedSprite2D= $Visual
func _physics_process(delta: float) -> void:
	velocity.y=min(velocity.y+ gravity* delta, max_fall_speed)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y= base_jump_velocity* GameManager.jump_mult
	var dir:= Input.get_axis("move_left", "move_right")
	velocity.x= dir* base_speed* GameManager.speed_mult
	
	var was_falling:= velocity.y> 0.0
	move_and_slide()
	for i in get_slide_collision_count():
		var col := get_slide_collision(i)
		var collider := col.get_collider()
		if collider !=null and is_instance_valid(collider) and collider.is_in_group("enemies"):
			if was_falling and col.get_normal().y<-0.4:
				_stomp(collider)
			elif not invincible:
				_hurt(collider)
	if invincible:
		invincible_timer-= delta
		visual.visible= int(invincible_timer* 12.0) % 2 ==0
		if invincible_timer <=0.0:
			invincible= false
			visual.visible=true
func _stomp(enemy:Node) -> void:
	velocity.y= base_stomp_bounce * GameManager.jump_mult
	enemy.take_hit(1+ GameManager.stomp_bonus)
func _hurt(enemy:Node) -> void:
	invincible=true
	invincible_timer= invincible_time
	var dir_sign:= signf(global_position.x- enemy.global_position.x)
	if dir_sign == 0.0:
		dir_sign=1.0
	velocity.x= knockback_x*dir_sign
	velocity.y= knockback_Y
	GameManager.lose_life()
