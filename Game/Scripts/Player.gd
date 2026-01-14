extends CharacterBody2D

@export var speed = 128
@export var gravity = 800
@export var jump_force = 400

@onready var sprite = $Sprite
@onready var spriteAnimator = $SpriteAnimator
@onready var collisionArea = $CollisionArea

var _scale = 0

var is_recording = true
var frame_data = []

func _ready() -> void:
	_scale = sprite.scale.x
	collisionArea.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	
	if(is_recording):
		record_data()
		
	apply_gravity(delta)
		
	var input_axis = Input.get_axis("ui_left", "ui_right")
	apply_horizontal_force(delta, input_axis)
	jump_check()
	update_animation(input_axis)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func apply_horizontal_force(delta, input_axis):
	if input_axis !=0:
		velocity.x = input_axis * speed
		sprite.scale.x = _scale * input_axis
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func jump_check():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force

func update_animation(input_axis):
	if input_axis != 0:
		spriteAnimator.play("Run")
		#spriteAnimator.speed_scale = input_axis * sprite.scale.x
	else:
		spriteAnimator.speed_scale = 1
		spriteAnimator.play("Idle")
	
	if not is_on_floor():
		spriteAnimator.play("Jump")

func record_data():
	var current_frame = {
		"pos" : global_position,
		"anim" : spriteAnimator.current_animation
	}
	frame_data.append(current_frame)

func _on_body_entered(body):
	if body.is_in_group("clones"):
		GameManager._end_level(self,body)
