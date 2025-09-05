extends Node2D

@onready var prompt: RichTextLabel = $Prompt
@onready var caret: ColorRect = $Caret
@onready var blink_timer: Timer = $CaretBlinkTimer
@onready var game_timer: Timer = $GameTimer
@onready var correct
@onready var font = prompt.get_theme_font("normal_font")
@onready var font_size = prompt.get_theme_font_size("normal_font_size")
@onready var text = prompt.get_text_without_tags()
@export var time_label: Label
@export var date_label: Label
@export var game_over_screen: Container

var current_letter_index := 0
var current_line := 0
var elapsed_time := 0
const INCORRECT_PENALTY := 6
const MINUTES_PER_GAME_SECOND := 10
const MINUTES_PER_DAY := 1440
const MINUTES_PER_HOUR := 60
const GAME_SECONDS_PER_HOUR := MINUTES_PER_HOUR/MINUTES_PER_GAME_SECOND
const GAME_SECONDS_PER_DAY := MINUTES_PER_DAY/MINUTES_PER_GAME_SECOND
const MAX_TIME := 4464

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if OS.is_keycode_unicode(event.keycode):
			var typed_char = String.chr(event.unicode)
			print("Pressed: " + typed_char)
			if current_letter_index >= text.length():
				return
			if typed_char == text[current_letter_index]:
				update_caret(current_letter_index)
				prompt.update_text(current_letter_index)
				$CorrectLetterSound.play()
				current_letter_index += 1
				if current_letter_index == text.length():
					print("Done")
					task_complete()
			else:
				$IncorrectLetterSound.play()
				elapsed_time += INCORRECT_PENALTY
				display_time()

func _ready():
	task_start()

func update_caret(index: int):
	var line = prompt.get_character_line(index + 1)
	if current_line != line:
		current_line = line
		var offset = prompt.get_line_offset(line)
		caret.position = prompt.position + Vector2(0,offset)
	else:
		var width = font.get_string_size(text[index],0,-1,font_size).x
		caret.position.x += width
	caret.visible = true
	blink_timer.start()
	
func display_time():
	var date_text = "2025-09-"
	var day = elapsed_time/GAME_SECONDS_PER_DAY
	date_text += "0" + str(day + 1) if day + 1 < 10 else str(day+1)		
	date_label.text = date_text
	
	var time_text = ""
	var remainder = elapsed_time - (day * GAME_SECONDS_PER_DAY)
	var hours = remainder/GAME_SECONDS_PER_HOUR
	var minutes = (remainder - (hours * GAME_SECONDS_PER_HOUR))*MINUTES_PER_GAME_SECOND
	time_text += "0" + str(hours) if hours < 10 else str(hours)
	time_text += ":"
	time_text += "0" + str(minutes) if minutes < 10 else str(minutes)
	
	time_label.text = time_text

func task_start():
	game_over_screen.hide()
	caret.show()
	caret.size = Vector2(2,font.get_height(font_size))
	caret.position = prompt.position
	current_letter_index = 0
	current_line = 0
	elapsed_time = 0
	game_timer.start()
	blink_timer.start()
	display_time()
	prompt.update_text(-1)
	
func task_complete():
	game_over_screen.show()
	game_timer.stop()
	blink_timer.stop()
	caret.hide()

func _on_restart_button_pressed() -> void:
	task_start()

func _on_caret_blink_timer_timeout() -> void:
	caret.visible = !caret.visible

func _on_game_timer_timeout():
	elapsed_time += 1
	display_time()
