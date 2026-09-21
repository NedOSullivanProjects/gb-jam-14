extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


#func reloadGame():
	#get_tree().reload_current_scene()


func _on_health_component_died() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menu/game_over.tscn")
	
