extends Node2D

@onready var player = $Player
@onready var timer_label = $UI/TimerLabel
@onready var score_label = $UI/ScoreLabel
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var clouds_layer = $ParallaxBackground/CloudsLayer
@onready var hills_layer = $ParallaxBackground/HillsLayer

var enemy_scene = preload("res://scenes/Enemy.tscn")
var game_active: bool = true

func _ready():
	Global.game_started = true
	Global.time_remaining = 60.0
	enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timer_timeout)
	enemy_spawn_timer.start()

func _process(delta: float):
	if not game_active:
		return
	
	# Update timer
	Global.time_remaining -= delta
	timer_label.text = "Time: %.1f" % max(0, Global.time_remaining)
	score_label.text = "Score: %d" % Global.score
	
	# Check win condition
	if Global.time_remaining <= 0:
		game_active = false
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
	
	# Scroll background (parallax effect with plane movement)
	clouds_layer.motion_offset.x -= 30 * delta
	hills_layer.motion_offset.x -= 80 * delta

func _on_enemy_spawn_timer_timeout():
	if not game_active:
		return
	
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	
	# Spawn at random height on right side
	var spawn_x = 1100
	var spawn_y = randf_range(100, 500)
	enemy.position = Vector2(spawn_x, spawn_y)

func game_over():
	game_active = false
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")