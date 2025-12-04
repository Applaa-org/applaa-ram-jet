extends Node

var score: int = 0
var time_remaining: float = 60.0
var game_started: bool = false

func reset_game():
	score = 0
	time_remaining = 60.0
	game_started = false

func add_score(points: int):
	score += points