extends RefCounted
class_name Stage

var projectiles := 0
var coins := 0
var target_scene_resource : PackedScene

func _init(_target_scene = "res://game/objects/targets/target/target.tscn"):
	target_scene_resource = load(_target_scene)
