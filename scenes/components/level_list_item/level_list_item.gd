class_name LevelListItem
extends PanelContainer

signal request_play(level_id: String)

@export var check_box: CheckBox
@export var level_name_label: Label
@export var play_icon: TextureRect
@export var accuracy_label: Label
@export var duration_label: Label

var _is_completed := false
var _accuracy: float
var _duration: int
var _level_id: String

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	play_icon.hide()
	accuracy_label.hide()
	duration_label.hide()

	if _is_completed:
		_on_level_updated(_level_id, _accuracy, _duration, _is_completed)
		return
	
	GameState.level_updated.connect(_on_level_updated)

func _gui_input(event: InputEvent) -> void:
	if _is_completed:
		return
	
	if event is not InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print_debug("Requesting to play " + _level_id)
		emit_signal("request_play", _level_id)

func set_level_data(level_data: LevelData) -> void:
	level_name_label.text = level_data.level_name
	_level_id = level_data.id
	_is_completed = level_data.is_completed

	if _is_completed:
		_accuracy = level_data.accuracy
		_duration = level_data.duration

func _on_level_updated(level_id: String, accuracy: float, duration: int, is_complete: bool) -> void:
	if level_id != _level_id:
		return

	duration_label.text = GameState.time_to_string(duration)
	accuracy_label.text = "%.1f%%" % accuracy
	
	if is_complete:
		check_box.button_pressed = true
		_is_completed = true
		duration_label.show()
		accuracy_label.show()
		play_icon.hide()

func _on_mouse_entered() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("hover", "LevelListItem"))
	level_name_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelListItem"))

	if not _is_completed:
		play_icon.show()
	else:
		accuracy_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelListItem"))
		duration_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelListItem"))

func _on_mouse_exited() -> void:
	remove_theme_stylebox_override("panel")
	level_name_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelListItem"))

	if not _is_completed:
		play_icon.hide()
	else:
		accuracy_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelListItem"))
		duration_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelListItem"))
