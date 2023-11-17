extends Node

var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()

var unit_id = "ca-app-pub-9485734485882503/3219588539"

func _ready():
	on_user_earned_reward_listener.on_user_earned_reward = on_user_earned_reward
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded

	full_screen_content_callback.on_ad_clicked = func():
		print("on_ad_clicked")
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func():
		print("on_ad_dismissed_full_screen_content")
		destroy_ad()
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError):
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_content_callback.on_ad_impression = func():
		print("on_ad_impression")
	full_screen_content_callback.on_ad_showed_full_screen_content = func():
		print("on_ad_showed_full_screen_content")

func destroy_ad():
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null

func on_user_earned_reward(rewarded_item : RewardedItem):
	Global.add_coins(50)
	Global.save_game()
	Events.rewarded_ad_was_watched.emit()

	load_ad()

func on_rewarded_ad_failed_to_load(adError : LoadAdError):
	print(adError.message)

func on_rewarded_ad_loaded(rewarded_ad : RewardedAd):
	rewarded_ad.full_screen_content_callback = full_screen_content_callback

	self.rewarded_ad = rewarded_ad
	
	Events.rewarded_ad_loaded.emit()

func load_ad():
	destroy_ad()

	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)

func show_ad():
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)

	destroy_ad()
