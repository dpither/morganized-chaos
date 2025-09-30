@tool
extends EditorScript

# (Average WPM = 45 * Average word length = 5) / 60 seconds in a minute
const AVG_CHARACTERS_PER_SECOND := 3.75
const ERROR_PERCENTAGE := 0.07
const ERROR_PENALTY := 5

func _run() -> void:
	var levels := _get_typing_levels()
	print("Stats for %d levels" % levels.size())
	var total_chars := 0
	for level in levels:
		total_chars += _get_stats(level, false).get("num_chars")

	print("Total characters: %d" % total_chars)
	_estimate_time(total_chars)

func _get_typing_levels() -> Array[LevelData]:
	var path := "res://resources/level_data/"
	var dir := DirAccess.open(path)
	var levels: Array[LevelData] = []

	for file in dir.get_files():
		if file.ends_with(".tres"):
			levels.append(load(path + file))

	return levels

func _get_stats(level: LevelData, verbose: bool) -> Dictionary:
	var level_content: TypingLevel = level.content.instantiate()
	var num_chars := 0
	var tasks := level_content.typing_tasks

	for task: TypingTask in tasks:
		num_chars += task.text.length()
	var stats = {
		"num_tasks": tasks.size(),
		"num_chars": num_chars,
	}
	
	if verbose:
		print("Stats for %s:" % level.id)
		print("	%d tasks, %d characters" % [tasks.size(), num_chars])
		
	return stats

func _estimate_time(total_chars: int) -> void:
	var perfect_time := (float(total_chars) / AVG_CHARACTERS_PER_SECOND) / 60
	print("Perfect time: %.2f minutes" % perfect_time)
	
	var num_errors := total_chars * ERROR_PERCENTAGE
	var penalty_time := (num_errors * ERROR_PENALTY) / 60
	print("Error percentage: %d%%" % (ERROR_PERCENTAGE * 100))
	print("	Num errors: %d" % num_errors)
	print("	Penalty time: %.2f minutes" % penalty_time)
	print("Total estimated average time: %.2f minutes" % (perfect_time + penalty_time))
