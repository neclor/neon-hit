extends AudioStreamPlayer

enum AUDIOS {PROJECTILE_HIT, TARGET_EXPLOSION}

const AUDIO_FILES := {
	AUDIOS.PROJECTILE_HIT: preload("res://assets/audio/projectile_hit.mp3"),
	AUDIOS.TARGET_EXPLOSION: preload("res://assets/audio/target_explosion.mp3")
}

func play_sound(sound: AUDIOS):
	stream = AUDIO_FILES.get(sound)
	play()
