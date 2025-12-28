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
	clone_spawn_timer.wait_time = 0.5  # Interval between clone spawns
	clone_spawn_timer.one_shot = false
	clone_spawn_timer.timeout.connect(_spawn_next_clone)
	add_child(clone_spawn_timer)
	
func spawn_player():
	var player = player_scene.instantiate()
	player.global_position = spawn.global_position
	player.add_to_group("player")
	add_child(player)

func _on_portal_entered(body):
	#if body.name == "Player":
		#if !is_second_run:
			#call_deferred("start_second_run")
		#else:
			#print("Level Complete!")
	
	if body.is_in_group("player"):
		# Save this run's recording
		recorded_ghost_data.append(body.frame_data.duplicate())
		body.queue_free()
		# Clear existing clones
		get_tree().call_group("clones", "queue_free")
		clone_spawn_timer.stop()
		
		run_count += 1
		call_deferred("spawn_player")
		
		var clones_to_spawn = recorded_ghost_data.size()
		if clones_to_spawn > 0:
			clone_spawn_timer.start()

func _spawn_next_clone():
	if recorded_ghost_data.size() > 0:
		var clone = clone_scene.instantiate()
		clone.global_position = portal.global_position
		clone.add_to_group("clones")
		add_child(clone)
		clone.start_replay(recorded_ghost_data.duplicate())
		clone_spawn_timer.start()

#func start_second_run():
	#print("Starting Run 2: Clone Activated")
	#
	## 1. Save data from Run 1
	#recorded_ghost_data = player.frame_data.duplicate()
	#
	## 2. Reset Player for Run 2
	#player.global_position = spawn.position # Ensure you have a Marker2D named SpawnPoint
	#player.frame_data.clear() # Clear data to maybe record Run 2 (optional)
	#player.velocity = Vector2.ZERO
	#
	## 3. Spawn Clone
	#var clone_path = "res://Game/GameScenes/Clone.tscn"
	#if ResourceLoader.exists(clone_path):
		#var clone_scene = load(clone_path)
		#var clone = clone_scene.instantiate()
		#
		#add_child(clone)
		#
		#clone.start_replay(recorded_ghost_data)
#
		#is_second_run = true
	#else:
		#printerr("ERROR: Clone scene NOT found at: ", clone_path)
