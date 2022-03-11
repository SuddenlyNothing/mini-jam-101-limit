extends VBoxContainer

onready var easy := $H/Easy
onready var medium := $H/Medium
onready var hard := $H/Hard
onready var reset_difficulty := $ResetDifficulty
onready var label := $Label


func load_data() -> void:
	if "difficulty" in Save.data:
		Variables.difficulty = Save.data.difficulty
	else:
		Save.data.difficulty = Variables.difficulty
	set_difficulty(Variables.difficulty)


func set_difficulty(diff: int) -> void:
	match diff:
		Variables.EASY:
			easy.disabled = true
			medium.disabled = false
			hard.disabled = false
			label.text = "Enemies and spikes do no damage"
		Variables.MEDIUM:
			easy.disabled = false
			medium.disabled = true
			hard.disabled = false
			label.text = "Enemies deal 3 damage"
		Variables.HARD:
			easy.disabled = false
			medium.disabled = false
			hard.disabled = true
			label.text = "Enemies deal 10 damage"
	reset_difficulty.disabled = diff == Variables.MEDIUM
	Variables.difficulty = diff
	Save.data.difficulty = Variables.difficulty


func _on_ResetDifficulty_pressed() -> void:
	set_difficulty(Variables.MEDIUM)
