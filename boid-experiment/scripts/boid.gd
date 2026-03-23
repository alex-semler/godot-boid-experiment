extends Area2D

@export var speed: int = 100
var velocity: Vector2 = Vector2.ZERO

@onready var sprite = $AnimatedSprite2D
@onready var viewport_size: Vector2 = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2.from_angle(randf() * TAU) * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (velocity * delta)
	position.x = fposmod(position.x, viewport_size.x)
	position.y = fposmod(position.y, viewport_size.y)
	sprite.rotation = velocity.angle() + PI/2
