extends CharacterBody2D

var replay_data = []
var current_frame_index = 0
@onready var sprite = $Sprite

func _physics_process(delta):
	if current_frame_index  < replay_data.size():
		var frame = replay_data[current_frame_index]
		global_position = frame["pos"]
		sprite.flip_h = frame["flip"]
		current_frame_index += 1
	else:
		queue_free()

func start_replay(data):
	replay_data = data
	current_frame_index = 0
	set_physics_process(true)
