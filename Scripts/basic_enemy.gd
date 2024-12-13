extends CharacterBody2D

@export var SPEED = 150.0
var direction = 1.0

func _physics_process(delta):
	translate(Vector2(SPEED * direction * delta, 0))

func _on_ray_cast_2d_on_hit():
	direction *= -1
	scale.x = direction
