extends Node

var player_scene = preload("res://Game/GameScenes/Player.tscn")
var clone_scene = preload("res://Game/GameScenes/Clone.tscn")

var player_switcher = preload("res://Game/Shaders/SwitcherSprite.tres")

var scene_manager : SceneManager

var scene_timer : Timer
var clone_spawn_timer : Timer
var recorded_ghost_data = []
var is_second_run = false
var is_fast_run = true

var current_level : int
var levels = preload("res://Game/GameScenes/Level_data.tres")

func _ready():
	
	current_level = 0
	
	clone_spawn_timer = Timer.new()
	clone_spawn_timer.wait_time = 2  # Interval between clone spawns
	clone_spawn_timer.one_shot = false
	clone_spawn_timer.timeout.connect(_spawn_next_clone)
	add_child(clone_spawn_timer)
	
	scene_timer = Timer.new()
	scene_timer.wait_time = 15
	scene_timer.one_shot = false
	scene_timer.timeout.connect(_restart_level)
	add_child(scene_timer)
	scene_timer.start()

func _restart_level():
	_end_level(null,null,false)

func spawn_player():
	var player = player_scene.instantiate()
	player.global_position = scene_manager.spawn.global_position
	player.add_to_group("player")
	scene_manager.add_child(player)

func _portal_entered(body):
	if(is_second_run):
		_end_level(null,null,true)
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
	_spawn_next_clone()

func _spawn_next_clone():
	if recorded_ghost_data.size() > 0:
		var clone = clone_scene.instantiate()
		clone.global_position = scene_manager.portal.global_position
		clone.add_to_group("clones")
		scene_manager.add_child(clone)
		clone.start_replay(recorded_ghost_data,is_fast_run)
		if(!is_fast_run):
			clone_spawn_timer.start()
		clone.connect("check_fast_run",_callback)

func _callback(fast:bool):
	is_fast_run = fast
	scene_manager._animate_switch()
	_start_second_run()

func _end_level(player,body,status):
	if(player != null and body != null):
		player.queue_free()
		body.queue_free()
	clone_spawn_timer.stop()
	is_second_run = false
	is_fast_run = true
	recorded_ghost_data = []
	player_switcher.set_shader_parameter("flip", false)
	#get_tree().call_deferred("reload_current_scene")
	_play_next_level(status)
	
func _play_next_level(status):
	if(status):
		current_level += 1
		get_tree().call_deferred("change_scene_to_packed", levels.Levels[current_level])
		
	else:
		get_tree().call_deferred("reload_current_scene")
	
