extends PanelContainer

@onready var error_label = %ErrorLabel
@onready var animation_player = $AnimationPlayer

func change_notification(text: String):
	start_animation()
	change_error_text(text)

func change_error_text(text: String):
	error_label.text = text

func start_animation():
	animation_player.stop()
	animation_player.play("appearance")

func _on_ok_button_pressed():
	self.visible = false
