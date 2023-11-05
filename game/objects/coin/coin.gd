extends Node2D

@onready var sprite := $CoinSprite
@onready var coin_particles := $CoinCPUParticles

const ANIMATION_TIME = 1.0

var is_hited := false

func _on_coin_area_body_entered(body):
	if not is_hited:
		is_hited = true

		Global.add_coins(1)

		await animation()
		queue_free()

func animation():
	var tween := create_tween()

	sprite.hide()

	tween.parallel().tween_property(coin_particles, "modulate", Color("ffffff00"), ANIMATION_TIME)
	coin_particles.rotation = -rotation
	coin_particles.emitting = true

	await tween.finished
