extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	Events.key_picked.emit()
	animation_player.play("pickup")

func Destroy():
	queue_free()
