extends Area2D

var traveled_distance = 0.0
var max_distance = 500.0
const SPEED = 300.0

func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	translate(direction * SPEED * delta)
	
	traveled_distance += SPEED * delta
	if traveled_distance > max_distance:
		queue_free()


func _on_body_entered(body):
	queue_free()
	
	if body.has_method("push_and_pull"):
		body.push_and_pull(self.name, global_position)
