extends CharacterBody2D

const SPEED: float = 200.0
const BULLET_SPEED: float = 800.0

var bullet_scene = preload("res://scenes/PlayerBullet.tscn")

@onready var sprite = $Sprite2D
@onready var shoot_timer = $ShootTimer

var can_shoot: bool = true

func _physics_process(delta: float):
	# Vertical movement (W/S or Up/Down)
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Clamp to screen bounds
	position.y = clamp(position.y, 50, 550)
	
	move_and_slide()

func _input(event):
	# Shoot on mouse click or spacebar
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()
	elif event.is_action_pressed("ui_accept"):
		shoot()

func shoot():
	if not can_shoot:
		return
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position + Vector2(40, 0)
	
	can_shoot = false
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true

func hit():
	var main = get_parent()
	if main.has_method("game_over"):
		main.game_over()