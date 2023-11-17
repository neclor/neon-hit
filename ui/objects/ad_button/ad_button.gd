extends "res://ui/objects/buy_button/buy_button.gd"

@onready var loading_container = %LoadingContainer

func _ready():
	Events.rewarded_ad_loaded.connect(rewarded_ad_loaded)

func rewarded_ad_loaded():
	show_button()

func show_button():
	loading_container.visible = false

func hide_button():
	loading_container.visible = true

func _on_button_pressed():
	pressed.emit()
	hide_button()
