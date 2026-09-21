extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Start"):
		get_tree().change_scene_to_file("res://level_r.tscn")


func _on_timer_timeout() -> void:
	visible = not visible
