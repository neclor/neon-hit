extends Node2D

var game_over_hud := load("res://ui/game_over_hud/game_over_hud.tscn")

@onready var projectile_shooter := $ProjectileShooter
@onready var target_marker := $TargetMarker

var target

func _ready():
	Events.game_over.connect(game_over)
	Events.stage_changed.connect(change_stage)
	Global.change_stage(1)

func change_stage(stage: Stage):
	Global.save_game()
	place_target(stage)

func place_target(stage: Stage):
	if target:
		target.queue_free()
	target = stage.target_scene_resource.instantiate()
	add_child(target)
	target.init_generated_objects(stage.projectiles, stage.coins)
	target.global_position = target_marker.global_position

func game_over():
	projectile_shooter.is_work = false
	show_game_over_hud()
	Global.save_game()
	Global.reset_score()

func show_game_over_hud():
	add_child(game_over_hud.instantiate())
	Hud.update_hud_game_over()
