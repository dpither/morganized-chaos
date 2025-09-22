class_name LevelSelect
extends Control

@export var scroll_container: ScrollContainer
@export var level_container: VBoxContainer
@export var level_item_scene: PackedScene
var app_window: AppWindow

func _ready() -> void:
	var scrollbar = scroll_container.get_v_scroll_bar()
	scrollbar.gui_input.connect(_on_scrollbar_gui_input)

	for level in GameState.levels:
		var level_item: LevelItem = level_item_scene.instantiate()
		level_item.set_level_data(level)
		level_item.request_play.connect(_on_request_play)
		level_container.add_child(level_item)

func _on_scrollbar_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	
	if not event.pressed:
		return

	if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
		AudioManager.play_sound(AudioManager.SOUND_TYPE.MOUSE_CLICKED)
		app_window.focus_requested.emit(app_window)

func _on_request_play(level_id: String) -> void:
	if app_window.window_manager:
		app_window.window_manager.open_window(level_id)
