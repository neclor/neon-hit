extends Node2D

var projectile_scene := load("res://game/objects/projectile/projectile.tscn")

@onready var projectile := $Projectile
@onready var timer := $Timer

var is_work := true

func _on_timer_timeout():
	create_new_knife()

func create_new_knife():
	projectile = projectile_scene.instantiate()
	add_child(projectile)

func _input(event: InputEvent):
	if is_work and \
	Global.projectiles > 0 and \
	event is InputEventScreenTouch and event.is_pressed() and \
	timer.is_stopped():

			projectile.throw()
			Global.remove_projectile()
			timer.start()
