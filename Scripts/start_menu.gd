extends CanvasLayer

@export var first_level : PackedScene

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(first_level)
	LevelTransition.fade_from_black()


func _on_quit_button_pressed():
	get_tree().quit()
	
