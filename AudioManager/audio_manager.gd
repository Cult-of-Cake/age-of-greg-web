extends Node2D

@export var mute: bool = false
@export var sounds: Dictionary = {}

func play_sfx(sound_path: String):
	if not mute:
		var stream : AudioStreamWAV = sounds[sound_path]
		stream.reset_state()
		if stream and has_node("SFX_Player"):
			$SFX_Player.stream = stream
			$SFX_Player.play()

func play_bgm(sound_path: String):
	if not mute:
		var stream = load(sound_path)
		
		if stream and has_node("BGM_Player"):
			$BGM_Player.stream = stream
			$BGM_Player.play()
