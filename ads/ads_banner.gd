extends Node

var ad_view : AdView

var unit_id = "ca-app-pub-9485734485882503/6879508233"

func _ready():
	MobileAds.initialize()

func show_ad_banner():
	if ad_view:
		ad_view.destroy()
		ad_view = null

	ad_view = AdView.new(unit_id, AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH), AdPosition.Values.BOTTOM)

	ad_view.load_ad(AdRequest.new())
	ad_view.show()
