extends Node

enum SCENES {START, GAME, SHOP}

signal scene_changed(scene: SCENES)
signal game_over
signal score_changed(score: int)
signal projectiles_counter_changed(projectiles: int)
signal stage_changed(stage: Stage)
signal coins_changed(coins: int)
signal active_projectile_changed(projectile_index: int)

signal rewarded_ad_loaded
signal rewarded_ad_was_watched
