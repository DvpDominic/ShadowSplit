extends CharacterBody2D

var replay_data = []
var curr_index = 0
@onready var sprite = $Sprite
@onready var spriteAnimator = $SpriteAnimator

func _physics_process(delta):
	if curr_index > -1:
		var frame = replay_data[curr_index]
		#var prev_frame = replay_data[curr_index - 1]
		#var diff = frame["pos"].x - prev_frame["pos"].x
		#if abs(diff) > 0.1:
				#sprite.flip_h = diff > 0
				
		global_position = frame["pos"]
		spriteAnimator.play(frame["anim"])
		curr_index -= 1
	else:
		queue_free()
	

func start_replay(data):
	replay_data = data
	curr_index = replay_data.size() - 1
	set_physics_process(true)
