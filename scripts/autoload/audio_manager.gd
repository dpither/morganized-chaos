extends Node

enum Sfx {
  mouse_click,
  type_correct,
}
var sfx := {
  Sfx.mouse_click: [preload("res://assets/audio/mouse_click.wav")],
  Sfx.type_correct: [
    preload("res://assets/audio/type_correct_1.wav"),
    preload("res://assets/audio/type_correct_2.wav"),
    preload("res://assets/audio/type_correct_3.wav"),
    preload("res://assets/audio/type_correct_4.wav"),
    preload("res://assets/audio/type_correct_5.wav"),
    preload("res://assets/audio/type_correct_6.wav")
  ]
}

var type

var num_sfx_players = 8
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_queue: Array[AudioStream] = []

func _ready() -> void:
  for i in num_sfx_players:
    var sfx_player = AudioStreamPlayer.new()
    add_child(sfx_player)
    sfx_player.bus = "sfx"
    sfx_players.append(sfx_player)
    sfx_player.finished.connect(_on_sfx_finished.bind(sfx_player))

func _process(_delta: float) -> void:
  if not sfx_queue.is_empty() and not sfx_players.is_empty():
    var sfx_player = sfx_players.pop_front()
    sfx_player.stream = sfx_queue.pop_front()
    sfx_player.play()

func play_sfx(sfx_name: Sfx) -> void:
  if sfx.has(sfx_name):
    var sfx_list = sfx[sfx_name]
    sfx_queue.append(sfx_list[randi() % sfx_list.size()])
  
func _on_sfx_finished(sfx_player: AudioStreamPlayer) -> void:
  sfx_players.append(sfx_player)
