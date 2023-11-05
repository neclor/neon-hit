extends Control

@onready var grid_container := $MarginContainer/RootVBoxContainer/GridContainer
@onready var buy_button = $MarginContainer/RootVBoxContainer/HBoxContainer/BuyButton
@onready var projectile_texture = $MarginContainer/RootVBoxContainer/ProjectileTexture

func _ready():
	Events.active_projectile_changed.connect(update_projectile_texture)
	update_projectile_texture(Global.active_projectile_index)

	check_buy_button_visible()

	for i in range(Global.PROJECTILE_TEXTURES.size()):
		var shop_item := grid_container.get_child(i)
		shop_item.initialize(i)

	AdsRewarded.load_ad()

func _on_buy_button_pressed():
	if Global.coins < Global.UNLOCK_COST:
		return

	var locked_projectiles := []
	for i in range(Global.PROJECTILE_TEXTURES.size()):
		if not Global.check_projectile_unlocked(i):
			locked_projectiles.append(i)

	if locked_projectiles.is_empty():
		return

	var random_index = locked_projectiles.pick_random()

	Global.unlock_projectile(random_index)
	Global.add_coins(-Global.UNLOCK_COST)
	Global.save_game()

	grid_container.get_child(random_index).unlock()

	check_buy_button_visible()

func _on_ad_button_pressed():
	AdsRewarded.show_ad()

func update_projectile_texture(_projectile_index: int):
	projectile_texture.texture = Global.PROJECTILE_TEXTURES[_projectile_index]

func check_buy_button_visible():
	if Global.unlocked_projectiles == 0b11111111:
		buy_button.visible = false



