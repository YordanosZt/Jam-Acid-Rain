extends RayCast2D

signal onHit

func _physics_process(delta):
	if is_colliding():
		onHit.emit()
