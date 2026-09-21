extends AudioStreamPlayer


var menuMusic = preload("res://Music/mainMenu.ogg")
func _ready():
		menuMusic.loop = true
func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()


func play_music_menu():
	_play_music(menuMusic)
