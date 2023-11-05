extends CanvasLayer

@onready var back_button := %BackButton
@onready var score_lable := %ScoreLable
@onready var levels_counter := %LevelsCounter
@onready var stage_label = %StageLabel
@onready var projectiles_counter := %ProjectilesCounter
@onready var coins_counter = %CoinsCounter/CoinLable

func _ready():
	Events.scene_changed.connect(update_hud_objects)
	Events.score_changed.connect(update_score)
	Events.coins_changed.connect(update_coins)
	Events.stage_changed.connect(update_stage_lable)
	update_coins(Global.coins)
	update_hud_objects(Events.SCENES.START)

func update_coins(coins: int):
	coins_counter.text = str(coins)

func update_score(score: int):
	score_lable.text = str(score)

func update_hud_objects(scene: Events.SCENES):
	match scene:
		Events.SCENES.START:
			back_button.hide()
			score_lable.hide()
			levels_counter.hide()
			stage_label.hide()
			projectiles_counter.hide()

		Events.SCENES.SHOP:
			back_button.show()
			score_lable.hide()
			levels_counter.hide()
			stage_label.hide()
			projectiles_counter.hide()

		Events.SCENES.GAME:
			back_button.hide()
			score_lable.show()
			levels_counter.show()
			stage_label.show()
			projectiles_counter.show()

func update_hud_game_over():
	back_button.show()
	score_lable.hide()
	levels_counter.hide()
	stage_label.hide()
	projectiles_counter.hide()

func update_stage_lable(stage: Stage):
	stage_label.text = "STAGE {0}".format([Global.stage_count])

func _on_back_button_pressed():
	Events.scene_changed.emit(Events.SCENES.START)
