extends CharacterBody2D

const SPEED := 5000.0

enum State {IDLE, FLY, FALLS}
var state := State.IDLE

const fall_speed = 1000.0
const fall_rotation_speed = 1500.0

var fall_direction := Vector2.DOWN

@onready var projectile_sprite = $ProjectileSprite

func _ready():
	projectile_sprite.texture = Global.PROJECTILE_TEXTURES[Global.active_projectile_index]

func change_state(new_state: State):
	state = new_state

func _physics_process(delta: float):
	match state:
		State.FLY:
			var throw_vector = Vector2.UP * SPEED * delta
			var collision_info = move_and_collide(throw_vector)
			if collision_info:
				handle_collision(collision_info)

		State.FALLS:
			global_position += fall_direction * fall_speed * delta
			rotation += fall_rotation_speed * delta

func throw():
	change_state(State.FLY)

func fall(direction: Vector2):
	change_state(State.FALLS)
	fall_direction = direction

func handle_collision(collision_info: KinematicCollision2D):
	var collider := collision_info.get_collider()

	if collider is Target:
		change_state(State.IDLE)
		add_knife_to_target(collider)
		collider.check_explode()
		Global.add_score()

	else:
		SfxPlayer.play_sound(SfxPlayer.AUDIOS.PROJECTILE_HIT)
		fall(collision_info.get_normal())
		Events.game_over.emit()

func add_knife_to_target(target: Target):
	get_parent().remove_child(self)
	global_position = Target.PROJECTILE_POSITION
	rotation = 0
	target.add_object_to_target(self, - target.rotation)
