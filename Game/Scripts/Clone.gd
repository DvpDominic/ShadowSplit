extends CharacterBody2D

var replay_data = []
var curr_index = 0
@onready var sprite = $Sprite

func _physics_process(delta):
	if curr_index > -1:
		var frame = replay_data[curr_index]
		global_position = frame["pos"]
		sprite.flip_h = frame["flip"]
		curr_index -= 1
	else:
		queue_free()

func start_replay(data):
	replay_data = data
	curr_index = replay_data.size() - 1
	set_physics_process(true)
