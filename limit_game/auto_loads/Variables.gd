extends Node

enum {
	EASY,
	MEDIUM,
	HARD,
}

# Used for input remapping and control displays
var user_keys = PoolStringArray(["pause", "up", "left", "right", "dash"])

var difficulty = MEDIUM

# Used for formatting strings to display the correct key.
var input_format = {}
