extends CharacterBody2D

const APPROACH_SPEED: float = 300.0
const DODGE_SPEED: float = 150.0
const SHOOT_DISTANCE: float = 400.0

var bullet_scene = preload("res://scenes/EnemyBullet.tscn")

@onready var sprite = $Sprite2D
@onready var shoot_timer = $ShootTimer

enum State { APPROACHING, DODGING }
var current_state = State.APPROACHING
var dodge_direction: float = 1.0
var player: Node2D = null

func _ready():
	add_to_group("enemy")
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	# Find player
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float):
	if current_state == State.APPROACHING:
		# Move towards player position
		velocity.x = -APPROACH_SPEED
		
		if player:
			var distance_to_player = position.x - player.position.x
			
			# Switch to dodging when close enough
			if distance_to_player < SHOOT_DISTANCE:
				current_state = State.DODGING
				shoot_timer.start()
				dodge_direction = 1.0 if randf() > 0.5 else -1.0
	
	elif current_state == State.DODGING:
		# Move slower horizontally
		velocity.x = -APPROACH_SPEED * 0.3
		
		# Dodge up and down
		velocity.y = dodge_direction * DODGE_SPEED
		
		# Clamp to screen and reverse direction
		if position.y < 100:
			dodge_direction = 1.0
		elif position.y > 500:
			dodge_direction = -1.0
		
		# Randomly change direction occasionally
		if randf() < 0.02:
			dodge_direction *= -1.0
	
	move_and_slide()
	
	# Remove if off-screen left
	if position.x < -100:
		queue_free()

func _on_shoot_timer_timeout():
	if current_state == State.DODGING and player:
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position + Vector2(-30, 0)

func hit():
	Global.add_score(100)
	queue_free()