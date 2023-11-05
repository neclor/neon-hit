extends CharacterBody2D
class_name Target

@onready var objects_container := $ObjectsContainer
@onready var sprite := $TargetSprite
@onready var projectile_particles := $ProjectileCPUParticles
@onready var target_particles_container = $TargetParticlesContainer

const ANIMATION_TIME = 1.0
const PROJECTILE_POSITION = Vector2(0, 176)
const COIN_POSITION = Vector2(0, 128)

var projectile_scene := load("res://game/objects/projectile/projectile.tscn")
var coin_scene := load("res://game/objects/coin/coin.tscn")

var speed := PI / 1.5

var init_projectiles
var init_coins

func _ready():
	projectile_particles.texture = Global.PROJECTILE_TEXTURES[Global.active_projectile_index]

func init_generated_objects(projectiles: int, coins: int):
	init_projectiles = projectiles
	init_coins = coins

func _physics_process(delta: float):
	if (init_projectiles != null):
		add_generated_objects(init_projectiles, init_coins)
		init_projectiles = null

	move(delta)

func check_explode():
	SfxPlayer.play_sound(SfxPlayer.AUDIOS.PROJECTILE_HIT)

	if Global.projectiles == 0:
		explode()

func explode():
	SfxPlayer.play_sound(SfxPlayer.AUDIOS.TARGET_EXPLOSION)

	await animation()

	Global.change_stage(Global.stage_count + 1)

func add_object_to_target(object: Node2D, object_rotation: float):
	var node_with_object := Node2D.new()

	node_with_object.rotation = object_rotation
	node_with_object.add_child(object)

	objects_container.add_child(node_with_object)

func add_generated_objects(projectiles: int, coins: int):
	var free_places := [0, 1, 2, 3, 4, 5, 6, 7]

	for i in range(projectiles):
		if free_places == []:
			return

		var value = choose_free_place(free_places)
		var projectile_rotation = value[0]
		free_places = value[1]

		var projectile = projectile_scene.instantiate()
		projectile.position = PROJECTILE_POSITION

		add_object_to_target(projectile, projectile_rotation)

	for i in range(coins):
		if free_places == []:
			return

		var value = choose_free_place(free_places)
		var coin_rotation = value[0]
		free_places = value[1]

		var coin = coin_scene.instantiate()
		coin.position = COIN_POSITION

		add_object_to_target(coin, coin_rotation)

func choose_free_place(free_places: Array):
	var place_index := Global.rng.randi_range(0, free_places.size() - 1)
	var place = free_places[place_index]
	free_places.remove_at(place_index)

	var object_rotation = place * PI / 4

	return [object_rotation, free_places]

func animation():
	var tween := create_tween()

	sprite.hide()
	objects_container.hide()

	tween.parallel().tween_property(projectile_particles, "modulate", Color("ffffff00"), ANIMATION_TIME)
	projectile_particles.rotation = -rotation
	projectile_particles.emitting = true

	for i in range(target_particles_container.get_child_count()):
		var target_particle = target_particles_container.get_child(i)

		tween.parallel().tween_property(target_particle, "modulate", Color("ffffff00"), ANIMATION_TIME)
		target_particle.rotation = -rotation
		target_particle.emitting = true

	await tween.finished

func move(delta: float):
	rotation += speed * delta
