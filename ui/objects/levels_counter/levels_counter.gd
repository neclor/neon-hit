extends HBoxContainer

func _ready():
	Events.stage_changed.connect(update_stage)

func update_stage(stage: Stage):
	var stage_count = Global.stage_count % Global.BOSS_LEVEL

	for i in range(Global.BOSS_LEVEL - 1):
		var level_texture := get_child(i)
		level_texture.visible = false if stage_count == 0 or i < stage_count - 1 else true
