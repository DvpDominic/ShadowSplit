extends Node

var player_scene = preload("res://Game/GameScenes/Player.tscn")
var clone_scene = preload("res://Game/GameScenes/Clone.tscn")

@onready var spawn = $SpawnPoint
@onready var portal = $Portal # Area2D trigger

var run_count = 0
var clone_spawn_timer : Timer
var recorded_ghost_data = []
var is_second_run = false

var current_clone_index: int = 0

func _ready():
	spawn_player()
	portal.body_entered.connect(_on_portal_entered)
	
	clone_spawn_timer = Timer.new()
	clone_spawn_timer.wait_time = 2.5  # Interval between clone spawns
	clone_spawn_timer.one_shot = false
	clone_spawn_timer.timeout.connect(_spawn_next_clone)
	add_child(clone_spawn_timer)
	
func spawn_player():
	var player = player_scene.instantiate()
	player.global_position = spawn.global_position
	player.add_to_group("player")
	add_child(player)

func _on_portal_entered(body):
	
	if body.is_in_group("player"):
		# Save this run's recording
		body.is_recording = false
		#recorded_ghost_data.append(body.frame_data.duplicate())
		recorded_ghost_data = body.frame_data
		body.queue_free()
		
		call_deferred("spawn_player")
		
		if recorded_ghost_data.size() > 0:
			_spawn_next_clone()

func _spawn_next_clone():
	if recorded_ghost_data.size() > 0:
		var clone = clone_scene.instantiate()
		clone.global_position = portal.global_position
		clone.add_to_group("clones")
		add_child(clone)
		clone.start_replay(recorded_ghost_data)
		clone_spawn_timer.start()
