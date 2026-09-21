extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playMusic.play_music_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
