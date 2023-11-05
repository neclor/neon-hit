extends Node

const PROJECTILE_TEXTURES := [
	preload("res://assets/sprite/projectile0.png"),
	preload("res://assets/sprite/projectile1.png"),
	preload("res://assets/sprite/projectile2.png"),
	preload("res://assets/sprite/projectile3.png"),
	preload("res://assets/sprite/projectile4.png"),
	preload("res://assets/sprite/projectile5.png"),
	preload("res://assets/sprite/projectile6.png"),
	preload("res://assets/sprite/projectile7.png")
]

const TARGETS := [
	"res://game/objects/targets/target/target.tscn",
	"res://game/objects/targets/target_accelerate/target_accelerate.tscn"
]

const BOSSES := [
	"res://game/objects/targets/target_boss/target_boss.tscn"
]

const BOSS_LEVEL := 5

const UNLOCK_COST := 100

const scene_path = {
	Events.SCENES.START: preload("res://ui/start_scene/start.tscn"),
	Events.SCENES.SHOP: preload("res://ui/shop_scene/shop.tscn"),
	Events.SCENES.GAME: preload("res://game/game_scene/game.tscn")
}

const SAVE_FILE := "user://savegame.save"
const SAVE_VARIABLES := ["coins", "active_projectile_index", "unlocked_projectiles"]

const MAX_STAGE_OBJECTS := 8
const MIN_PROJECTILES := 8
const MAX_PROJECTILES := 8

var rng := RandomNumberGenerator.new()

var stage_count := 1
var score := 0
var projectiles := 8
var coins := 0

var active_projectile_index := 0
var unlocked_projectiles := 0b00000001

func unlock_projectile(projectile_index: int):
	unlocked_projectiles |= (1 << projectile_index)

func check_projectile_unlocked(projectile_index: int):
	return unlocked_projectiles & (1 << projectile_index) != 0

func save_game():
	var save_game_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if save_game_file == null:
		printerr("фаил не найден {0}".format([FileAccess.get_open_error()]))
		return

	var game_data := {}

	for variable in SAVE_VARIABLES:
		game_data[variable] = get(variable)

	var json_object := JSON.new()
	save_game_file.store_line(json_object.stringify(game_data))

func load_game():
	if not FileAccess.file_exists(SAVE_FILE):
		return

	var save_game_file = FileAccess.open(SAVE_FILE, FileAccess.READ)

	if save_game_file == null:
		printerr("фаил не найден {0}".format([FileAccess.get_open_error()]))
		return

	var json_object = JSON.new()
	var error = json_object.parse(save_game_file.get_line())
	if error != OK:
		return

	var game_data = json_object.get_data()
	for variable in SAVE_VARIABLES:
		if variable in game_data:
			set(variable, game_data[variable])

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		#get_tree().quit()

func _ready():
	load_game()
	rng.randomize()
	seed(rng.seed)
	Events.scene_changed.connect(handle_scene_change)

	AdsBanner.show_ad_banner()

func handle_scene_change(scene: Events.SCENES):
	get_tree().change_scene_to_packed(scene_path.get(scene))

func get_random_stage():
	var stage := Stage.new(TARGETS.pick_random())

	stage.projectiles = rng.randi_range(0, MAX_STAGE_OBJECTS)
	stage.coins = rng.randi_range(0, MAX_STAGE_OBJECTS)

	return stage

func change_stage(stage_i: int):
	stage_count = stage_i
	var stage: Stage

	if stage_count % BOSS_LEVEL == 0:
		stage = Stage.new(BOSSES.pick_random())

	else:
		stage = Stage.new() if stage_count == 1 else get_random_stage()

	projectiles = rng.randi_range(MIN_PROJECTILES, MAX_PROJECTILES)
	Events.projectiles_counter_changed.emit(projectiles)
	Events.stage_changed.emit(stage)

func change_projectile(projectile_index: int):
	active_projectile_index = projectile_index
	Events.active_projectile_changed.emit(active_projectile_index)

func remove_projectile():
	projectiles -= 1
	Events.projectiles_counter_changed.emit(projectiles)

func add_coins(new_coins: int):
	coins += new_coins
	Events.coins_changed.emit(coins)

func add_score():
	score += 1
	Events.score_changed.emit(score)

func reset_score():
	score = 0
	Events.score_changed.emit(score)
