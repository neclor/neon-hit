extends Control

func _on_start_button_pressed():
	Events.scene_changed.emit(Events.SCENES.GAME)

func _on_shop_button_pressed():
	Events.scene_changed.emit(Events.SCENES.SHOP)
