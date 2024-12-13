extends Area2D

@onready var weapon_pivot = $WeaponPivot
@onready var crosshair = $crosshair
@onready var firing_point = $WeaponPivot/Sprite2D/FiringPoint
@onready var shoot_audio = $ShootAudio

var mouse_position = Vector2.ZERO
var fire_rate = 2
var next_time_to_shoot = 0.0

var bullet_push = preload("res://Scenes/Items/bullet_push.tscn")
var bullet_pull = preload("res://Scenes/Items/bullet_pull.tscn")

@onready var allowSound = false

func _process(delta):
	mouse_position = get_global_mouse_position()
	
	weapon_pivot.look_at(mouse_position)
	crosshair.global_position = mouse_position
	
	if Input.is_action_just_pressed("shoot_push"):
		shoot_push()
		shoot_audio.pitch_scale = 1.0
		if allowSound:
			shoot_audio.play()
		
	if Input.is_action_just_pressed("shoot_pull"):
		shoot_pull()
		shoot_audio.pitch_scale = 3.0
		if allowSound:
			shoot_audio.play()

	
func shoot_push():
	var _bullet = bullet_push.instantiate()
	_bullet.global_position = firing_point.global_position
	_bullet.global_rotation = firing_point.global_rotation
	firing_point.add_child(_bullet)

func shoot_pull():
	var _bullet = bullet_pull.instantiate()
	_bullet.global_position = firing_point.global_position
	_bullet.global_rotation = firing_point.global_rotation
	firing_point.add_child(_bullet)

func setAllowSound(isAllowed):
	allowSound = isAllowed
