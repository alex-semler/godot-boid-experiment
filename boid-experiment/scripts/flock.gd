extends Node2D

@export var flock_size: int = 20

var boid_scene = preload("res://scenes/boid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	for i in range(flock_size):
		var boid = boid_scene.instantiate()
		boid.position = viewport_size / 2
		boid.speed = randi_range(100, 150)
		add_child(boid)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
