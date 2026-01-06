extends Node
class_name SceneManager

@onready var spawn = $SpawnPoint
@onready var portal = $Portal

func _ready():
	portal.body_entered.connect(_on_portal_entered)
	GameManager.scene_manager = self
	GameManager.spawn_player()
	
func _on_portal_entered(body):
	if body.is_in_group("player"):
		GameManager._portal_entered(body)
