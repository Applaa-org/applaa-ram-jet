extends Area2D

const SPEED: float = 600.0

func _ready():
	add_to_group("enemy_bullet")
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float):
	position.x -= SPEED * delta
	
	# Remove if off-screen
	if position.x < -100:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.hit()
		queue_free()