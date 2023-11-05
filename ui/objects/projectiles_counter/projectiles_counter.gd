extends VBoxContainer

var projectile_texture := load("res://assets/sprite/projectile_count.png")

func _ready():
	Events.projectiles_counter_changed.connect(update_projectiles_counter)

func update_projectiles_counter(projectiles: int):
	var projectiles_diff = projectiles - get_child_count()

	if projectiles_diff > 0:
		add_projectiles(projectiles_diff)

	elif projectiles_diff < 0:
		remove_projectile(- projectiles_diff)

func create_projectile_icon():
	var projectile := TextureRect.new()
	projectile.texture = projectile_texture
	return projectile

func add_projectiles(projectiles: int):
	for i in range(projectiles):
		add_child(create_projectile_icon())

func remove_projectile(projectiles: int):
	for i in range(projectiles):
		get_child(i).queue_free()
