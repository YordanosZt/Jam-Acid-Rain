extends CharacterBody2D

@onready var shield = $Shield
@onready var gun = $Gun
@onready var acidic_timer = $AcidicTimer
@onready var acidic_timer_label = $AcidicTimerLabel
@onready var sprite = $Sprite2D

@onready var isAcidic = false
@onready var hasShield = false
@onready var max_shield_health = 100.0

@onready var jump_audio = $JumpAudio
@onready var pickup_audio = $PickupAudio
@onready var land_audio = $LandAudio

@onready var die_animation = $DieAnimation

var current_shield_health = 0.0
var isInAcid = false

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var starting_position = Vector2.ZERO


func _ready():
	current_shield_health = max_shield_health
	sprite.texture = ResourceLoader.load("res://Assets/character_roundYellow.png")
	starting_position = global_position
	
	Events.use_gun.connect(use_gun)

#@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	if acidic_timer.time_left > 0:
		acidic_timer_label.text = str(int(acidic_timer.time_left) + 1)
	else:
		acidic_timer_label.text = ""
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_audio.play()

	var input_axis = Input.get_axis("move_left", "move_right")
	if input_axis:
		velocity.x = input_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animations(input_axis)
	
	if hasShield and isInAcid:
		current_shield_health -= delta * 30.0
		shield.scale = Vector2(current_shield_health / 100, shield.scale.y)
		
		if current_shield_health <= 0.0:
			hasShield = false

	var was_on_air = not is_on_floor()

	move_and_slide()
	
	var landed = was_on_air and is_on_floor()
	
	if landed:
		land_audio.play()
	
	if hasShield or isAcidic:
		return
		
	if isInAcid:
		die()

func update_animations(input_axis):
	if input_axis:
		$Sprite2D.flip_h = input_axis < 0
	
	#if is_on_floor():
		#if input_axis == 0:
			#animated_sprite.play("idle")
		#else:
			#animated_sprite.play("run")
	#else:
		#if velocity.y > 0:
			#animated_sprite.play("fall")
		#else:
			#animated_sprite.play("jump")

func die():
	#global_position = starting_position
	die_animation.play("die")
	
	
func reload():
	get_tree().reload_current_scene()
	
	
func use_gun():
	gun.setAllowSound(true)
	gun.show()

func _on_acid_detector_area_entered(area):
	isInAcid = true

func _on_acid_detector_area_exited(area):
	isInAcid = false

func _on_shield_detector_area_entered(area):
	shield.show()
	hasShield = true
	area.queue_free()
	pickup_audio.play()


func _on_end_detector_area_entered(area):
	Events.level_completed.emit()


func _on_enemy_detector_body_entered(body):
	die()


func _on_bucket_detector_body_entered(body):
	if body.has_method("getIsFilled"):
		if body.getIsFilled() == true:
			sprite.texture = ResourceLoader.load("res://Assets/character_squareGreen.png")
			isAcidic = true
			acidic_timer.start()
			body.queue_free()
			pickup_audio.play()


func _on_acidic_timer_timeout():
	isAcidic = false
	sprite.texture = ResourceLoader.load("res://Assets/character_roundYellow.png")
	
