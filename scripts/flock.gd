class_name Flock
extends Node2D

@export var settings: SimulationSettings

var BoidScene: PackedScene = preload("res://scenes/boid.tscn")

func _ready() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	for i in range(settings.flock_size):
		var boid: Boid = BoidScene.instantiate()
		boid.position = Vector2(viewport_size.x / i, viewport_size.y)
		add_child(boid)

func _process(delta: float) -> void:
	pass
