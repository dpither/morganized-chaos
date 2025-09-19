class_name ComputerScreen
extends Control

func _gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return

	if not event.pressed:
		return
		
	if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
		AudioManager.play_sound(AudioManager.SOUND_TYPE.MOUSE_CLICKED)