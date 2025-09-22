class_name LevelItem
extends PanelContainer

signal request_play(level_id: String)

@export var check_box: CheckBox
@export var title_label: Label
@export var play_icon: TextureRect
@export var accuracy_label: Label
@export var duration_label: Label

var _is_completed = false
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
		_on_level_completed(_level_id, _accuracy, _duration)
		return
	
	GameState.level_completed.connect(_on_level_completed)


func _gui_input(event: InputEvent) -> void:
	if _is_completed:
		return
	
	if event is not InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print_debug("Requesting to play " + _level_id)
		emit_signal("request_play", _level_id)

func set_level_data(level_data: LevelData) -> void:
	title_label.text = level_data.level_name
	_level_id = level_data.id
	_is_completed = level_data.is_completed	
	if _is_completed:
		_accuracy = level_data.accuracy
		_duration = level_data.duration

func _on_level_completed(level_id: String, accuracy: float, duration: int) -> void:
	if level_id != _level_id:
		return

	_is_completed = true
	check_box.button_pressed = true
	duration_label.text = GameState.time_to_string(duration)
	duration_label.show()
	accuracy_label.text = "%.1f%%" % accuracy
	accuracy_label.show()
	# title_label.set("theme_override_colors/font_color", get_theme_color("font_disabled_color", "LevelItem"))
	play_icon.hide()

func _on_mouse_entered() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("hover", "LevelItem"))
	title_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelItem"))
	if not _is_completed:
		play_icon.show()
	else:
		accuracy_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelItem"))
		duration_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelItem"))

func _on_mouse_exited() -> void:
	remove_theme_stylebox_override("panel")
	title_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelItem"))
	if not _is_completed:
		play_icon.hide()
	else:
		accuracy_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelItem"))
		duration_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelItem"))
