extends PanelContainer
class_name LevelItem

signal request_play(level_id: String)

@export var check_box: CheckBox
@export var title_label: Label
@export var play_icon: TextureRect
var _is_completed = false

var _level_id: String

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	check_box.disabled = true
	play_icon.hide()

	if _is_completed:
		_on_level_completed(_level_id)
		return
	
	GameState.level_completed.connect(_on_level_completed)


func _gui_input(event: InputEvent) -> void:
	if _is_completed:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print_debug("Requesting to play " + _level_id)
				emit_signal("request_play", _level_id)

func set_level_data(level_data: LevelData) -> void:
	title_label.text = level_data.title
	_level_id = level_data.id
	_is_completed = level_data.is_completed
	

func _on_level_completed(level_id: String) -> void:
	if level_id != _level_id:
		return

	_is_completed = true
	check_box.button_pressed = true
	title_label.set("theme_override_colors/font_color", get_theme_color("font_disabled_color", "LevelItem"))
	play_icon.hide()

func _on_mouse_entered() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("hover", "LevelItem"))
	if not _is_completed:
		play_icon.show()
		title_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelItem"))

func _on_mouse_exited() -> void:
	remove_theme_stylebox_override("panel")
	if not _is_completed:
		play_icon.hide()
		title_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelItem"))
