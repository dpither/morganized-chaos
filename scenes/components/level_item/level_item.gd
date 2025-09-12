extends PanelContainer
class_name LevelItem

signal request_play(name: String)

@export var checkbox: CheckBox
@export var name_label: Label
@export var play_icon: TextureRect
var is_completed = false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
#	TODO: REMOVE LATER
	checkbox.pressed.connect(_on_check_box_pressed)
	play_icon.hide()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("request_play", name_label.text)

func on_item_completed():
	is_completed = true
	checkbox.disabled = true
	checkbox.button_pressed = true
	name_label.set("theme_override_colors/font_color", get_theme_color("font_disabled_color", "LevelItem"))
	play_icon.hide()

func _on_mouse_entered() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("hover", "LevelItem"))
	if not is_completed:
		play_icon.show()
		name_label.set("theme_override_colors/font_color", get_theme_color("font_hover_color", "LevelItem"))

func _on_mouse_exited() -> void:
	remove_theme_stylebox_override("panel")
	if not is_completed:
		play_icon.hide()
		name_label.set("theme_override_colors/font_color", get_theme_color("font_color", "LevelItem"))


func _on_check_box_pressed() -> void:
	on_item_completed()
