extends Node2D

@export var FLOCK_SIZE: int = 20

var BoidScene: PackedScene = preload("res://scenes/boid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	for i in range(FLOCK_SIZE):
		var boid = BoidScene.instantiate()
		boid.position = Vector2(viewport_size.x / i, viewport_size.y)
		boid.speed = randi_range(100, 150)
		add_child(boid)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
