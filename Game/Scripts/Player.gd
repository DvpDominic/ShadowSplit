extends CharacterBody2D

const speed: float = 100
const jump_force: float = -200
const gravity = 600

var vel = Vector2.ZERO

func _physics_process(delta):
	vel.x = 0
	
	if Input.is_action_pressed("ui_right"):
		vel.x += speed
	elif Input.is_action_pressed("ui_right"):
		vel.x -= speed
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vel.y = jump_force
	else:
		vel.y += gravity * delta
		
	
