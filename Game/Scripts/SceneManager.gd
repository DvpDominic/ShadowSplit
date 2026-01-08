extends Node
class_name SceneManager

@onready var spawn = $SpawnPoint
@onready var portal = $Portal
@export var switch_rect : ColorRect
@export var switcher : ShaderMaterial

func _ready():
	switcher.set_shader_parameter("flip",0)
	portal.body_entered.connect(_on_portal_entered)
	GameManager.scene_manager = self
	GameManager.spawn_player()
	switch_rect.scale = Vector2(0,1)
	
func _on_portal_entered(body):
	if body.is_in_group("player"):
		GameManager._portal_entered(body)
		_animate_switch()

func _animate_switch():
	switcher.set_shader_parameter("flip",1)
	var tween = create_tween()
	tween.tween_property(switch_rect, "scale", Vector2(1, 1), 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
