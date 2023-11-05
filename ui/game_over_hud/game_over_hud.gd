extends CanvasLayer

@onready var score_label = %ScoreLabel

func _ready():
	score_label.text = str(Global.stage_count)

func _on_restart_button_pressed():
	Events.scene_changed.emit(Events.SCENES.GAME)
