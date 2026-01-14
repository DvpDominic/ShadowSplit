extends Node

var player_scene = preload("res://Game/GameScenes/Player.tscn")
var clone_scene = preload("res://Game/GameScenes/Clone.tscn")

var player_switcher = preload("res://Game/Shaders/SwitcherSprite.tres")

var scene_manager : SceneManager

var clone_spawn_timer : Timer
var recorded_ghost_data = []
var is_second_run = false
var is_fast_run = true

func _ready():
	
	clone_spawn_timer = Timer.new()
	clone_spawn_timer.wait_time = 2.5  # Interval between clone spawns
	clone_spawn_timer.one_shot = false
	clone_spawn_timer.timeout.connect(_spawn_next_clone)
	add_child(clone_spawn_timer)
	
func spawn_player():
	var player = player_scene.instantiate()
	player.global_position = scene_manager.spawn.global_position
	player.add_to_group("player")
	scene_manager.add_child(player)

func _portal_entered(body):
	if(is_second_run):
		_end_level(null,null)
		return
	else:
		is_second_run = true
		
	player_switcher.set_shader_parameter("flip", true)
	# Save this run's recording
	body.is_recording = false
	recorded_ghost_data = body.frame_data
	body.queue_free()
	
	if recorded_ghost_data.size() > 0:
		call_deferred("_spawn_next_clone")

func _start_second_run():
	call_deferred("spawn_player")

func _spawn_next_clone():
	if recorded_ghost_data.size() > 0:
		var clone = clone_scene.instantiate()
		clone.global_position = scene_manager.portal.global_position
		clone.add_to_group("clones")
		scene_manager.add_child(clone)
		clone.start_replay(recorded_ghost_data,is_fast_run)
		clone_spawn_timer.start()
		clone.connect("check_fast_run",_callback)

func _callback(fast:bool):
	is_fast_run = fast
	_start_second_run()

func _end_level(player,body):
	if(player != null and body != null):
		player.queue_free()
		body.queue_free()
	is_second_run = false
	is_fast_run = true
	recorded_ghost_data = []
	get_tree().reload_current_scene()
