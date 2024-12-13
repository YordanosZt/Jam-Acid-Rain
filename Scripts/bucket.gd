extends RigidBody2D

var multiplier = 1.0
var isFilled = false

@onready var acid_rain_det = $AcidRainDet
@onready var acid_indicator = $AcidIndicator

func _ready():
	acid_indicator.visible = isFilled

func push_and_pull(name, position):
	if name == "bullet_push":
		multiplier = -1.0
	elif name == "bullet_pull":
		multiplier = 1.0
		
	var vector = position - global_position
	var magnitude = sqrt(vector.x * vector.x + vector.y * vector.y)
	var unit_vector = vector / magnitude
	
	apply_central_impulse(unit_vector * 100.0 * multiplier)

func getIsFilled():
	return isFilled


func _on_acid_rain_det_area_entered(area):
	print("Acid Entered")
	isFilled = true
	acid_indicator.visible = isFilled
