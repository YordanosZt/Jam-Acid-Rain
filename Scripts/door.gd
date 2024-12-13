extends AnimatableBody2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("RESET")
	Events.key_picked.connect(open_door)
	
func open_door():
	animation_player.play("open")
