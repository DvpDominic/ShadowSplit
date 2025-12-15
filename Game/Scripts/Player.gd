extends CharacterBody2D

@export var acceleration = 512
@export var max_velocity = 64
@export var friction = 0.25
@export var gravity = 200
@export var jump_force = 128
@export var max_fall_velocity = 128

@onready var sprite = $Sprite
@onready var spriteAnimator = $SpriteAnimator

func _physics_process(delta):
	
	apply_gravity(delta)
		
	var input_axis = Input.get_axis("ui_left", "ui_right")
	apply_horizontal_force(delta, input_axis)
	jump_check()
		
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)

func apply_horizontal_force(delta, input_axis):
	if input_axis !=0:
		velocity.x = move_toward(velocity.x, input_axis * max_velocity, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func jump_check():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force

func update_animation(input_axis):
	if input_axis.x != 0:
		#sprite.scale.x = sign(input_vector.x)
		spriteAnimator.play("Run")
		spriteAnimator.playback_speed = input_axis.x * sprite.scale.x
	else:
		spriteAnimator.playback_speed = 1
		spriteAnimator.play("Idle")
	
	if not is_on_floor():
		spriteAnimator.play("Jump")
