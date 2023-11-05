extends PanelContainer

enum State {OPEN, ACTIVE}

var projectile_index := 0

@onready var projectile_texture = $MarginContainer/ProjectileTexture

func _ready():
	Events.active_projectile_changed.connect(update_projectile_status)

func change_state(state: State):
	projectile_texture.texture = Global.PROJECTILE_TEXTURES[projectile_index]

func initialize(_projectile_index: int):
	projectile_index = _projectile_index

	if Global.active_projectile_index == _projectile_index:
		change_state(State.ACTIVE)

	elif Global.check_projectile_unlocked(_projectile_index):
		change_state(State.OPEN)

func unlock():
	change_state(State.OPEN)

func update_projectile_status(_active_projectile_index: int):
	if projectile_index == _active_projectile_index:
		change_state(State.ACTIVE)
	elif Global.check_projectile_unlocked(projectile_index):
		change_state(State.OPEN)

func _on_button_pressed():
	if not Global.check_projectile_unlocked(projectile_index):
		return

	Global.change_projectile(projectile_index)
	Global.save_game()
