extends Area2D

const SPEED: float = 800.0

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float):
	position.x += SPEED * delta
	
	# Remove if off-screen
	if position.x > 1200:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit()
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		if area.has_method("hit"):
			area.hit()
		queue_free()