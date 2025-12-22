extends Node

@onready var player = $Player
@onready var portal = $Portal # Area2D trigger
var recorded_ghost_data = []
var is_second_run = false

func _ready():
	portal.body_entered.connect(_on_portal_entered)

func _on_portal_entered(body):
	if body.name == "Player":
		if !is_second_run:
			call_deferred("start_second_run")
		else:
			print("Level Complete!")

func start_second_run():
	print("Starting Run 2: Clone Activated")
	
	# 1. Save data from Run 1
	recorded_ghost_data = player.frame_data.duplicate()
	
	# 2. Reset Player for Run 2
	player.global_position = $SpawnPoint.position # Ensure you have a Marker2D named SpawnPoint
	player.frame_data.clear() # Clear data to maybe record Run 2 (optional)
	player.velocity = Vector2.ZERO
	
	# 3. Spawn Clone
	var clone_path = "res://Game/GameScenes/Clone.tscn"
	if ResourceLoader.exists(clone_path):
		print("DEBUG: Clone scene found at path!")
		var clone_scene = load(clone_path)
		var clone = clone_scene.instantiate()
		
		add_child(clone)
		print("DEBUG: Clone added to Scene Tree")
		
		clone.start_replay(recorded_ghost_data)
		print("DEBUG: Replay started")
		is_second_run = true
	else:
		printerr("ERROR: Clone scene NOT found at: ", clone_path)
