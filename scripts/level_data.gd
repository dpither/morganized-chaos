class_name LevelData
extends AppData

@export var is_completed: bool
@export var mistake_multiplier := 1
@export var level_name: String
@export var accuracy := 0.0
@export var duration := 0
@export var is_unlocked := false
@export var prerequisites: Array[LevelData] = []
