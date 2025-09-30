extends Node

enum SOUND_TYPE {
  MOUSE_CLICKED,
  TYPED_CORRECT,
  TYPED_INCORRECT,
  LEVEL_COMPLETED
}
enum MUSIC_TYPE {
  COMPUTER_HUM
}

const DEFAULT_MUSIC_VOLUME := -24.0
const DEFAULT_SOUND_VOLUME := -18.0
const MUTE_VOLUME := -60.0

var music_volume: float
var sound_volume: float

var _music_dict := {
  MUSIC_TYPE.COMPUTER_HUM: preload("res://assets/audio/computer_hum.wav"),
}
var _sound_dict := {
  SOUND_TYPE.MOUSE_CLICKED: [preload("res://assets/audio/mouse_click.wav")],
  SOUND_TYPE.TYPED_CORRECT: [
    preload("res://assets/audio/type_correct_1.wav"),
    preload("res://assets/audio/type_correct_2.wav"),
    preload("res://assets/audio/type_correct_3.wav"),
    preload("res://assets/audio/type_correct_4.wav"),
    preload("res://assets/audio/type_correct_5.wav"),
  ],
  SOUND_TYPE.TYPED_INCORRECT: [
    preload("res://assets/audio/type_incorrect_1.wav"),
    preload("res://assets/audio/type_incorrect_2.wav"),
    preload("res://assets/audio/type_incorrect_3.wav"),
  ],
  SOUND_TYPE.LEVEL_COMPLETED: [
    preload("res://assets/audio/level_complete.wav"),
  ],
}
var _num_sound_players := 8
var _sound_players: Array[AudioStreamPlayer] = []
var _sound_queue: Array[AudioStream] = []

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS

  set_music_volume(DEFAULT_MUSIC_VOLUME)
  set_sound_volume(DEFAULT_SOUND_VOLUME)

  for i in _num_sound_players:
    var sound_player := AudioStreamPlayer.new()
    add_child(sound_player)
    sound_player.bus = "sound"
    _sound_players.append(sound_player)
    sound_player.finished.connect(_on_sound_finished.bind(sound_player))
  
  var music_player := AudioStreamPlayer.new()
  add_child(music_player)
  music_player.stream = _music_dict[MUSIC_TYPE.COMPUTER_HUM]
  music_player.bus = "music"
  music_player.play()

func _process(_delta: float) -> void:
  if not _sound_queue.is_empty() and not _sound_players.is_empty():
    var sound_player = _sound_players.pop_front()
    sound_player.stream = _sound_queue.pop_front()
    sound_player.play()

func play_sound(type: SOUND_TYPE) -> void:
  if _sound_dict.has(type):
    var sound_list = _sound_dict[type]
    _sound_queue.append(sound_list[randi() % sound_list.size()])
  
func set_music_volume(volume: float) -> void:
  music_volume = volume
  _set_bus_volume("music", volume)

func set_sound_volume(volume: float) -> void:
  sound_volume = volume
  _set_bus_volume("sound", volume)
  
func _on_sound_finished(sfx_player: AudioStreamPlayer) -> void:
  _sound_players.append(sfx_player)

func _set_bus_volume(bus_name: String, volume: float) -> void:
  var bus_index := AudioServer.get_bus_index(bus_name)

  if bus_index == -1:
    push_error("No bus with name " + bus_name)
    return

  if volume == MUTE_VOLUME:
    AudioServer.set_bus_mute(bus_index, true)
  else:
    AudioServer.set_bus_mute(bus_index, false)
    AudioServer.set_bus_volume_db(bus_index, volume)
