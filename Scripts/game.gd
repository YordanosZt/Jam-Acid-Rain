extends Node2D

@export var next_level : PackedScene
@export var uses_gun = false
@onready var end_audio = $EndAudio

func _ready():
	if uses_gun:
		Events.use_gun.emit()
		
		
	Events.level_completed.connect(level_complete)
	
func go_to_next_level():
	print(next_level)
	
	if not next_level is PackedScene:
		next_level = load("res://Scenes/UI/victory_screen.tscn")
		
	get_tree().paused = true
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	LevelTransition.fade_from_black()
	
func level_complete():
	end_audio.play()
	go_to_next_level()
