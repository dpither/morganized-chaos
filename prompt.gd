extends RichTextLabel

@export var not_typed_color: Color
@export var typed_color: Color
	
func get_text_without_tags() -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(text, "",true)

func update_text(index: int):
	var raw_text = get_text_without_tags()
	var typed_text = "[color=#" + typed_color.to_html(false) + "]" + raw_text.substr(0,index+1) + "[/color]"
	var not_typed_text = "[color=#" + not_typed_color.to_html(false) + "]" + raw_text.substr(index+1,raw_text.length()-index-1) + "[/color]"
	parse_bbcode(typed_text + not_typed_text)
