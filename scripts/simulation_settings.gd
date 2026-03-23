class_name SimulationSettings
extends Resource

@export_group("Flock Settings")
@export var flock_size: int = 20

@export_group("Boid Settings")
@export var initial_speed: Vector2 = Vector2(100, 250)
@export_range(0, 360) var fov_angle: int = 120
@export_range(0.0, 1.0) var separation_weight: float = 0.5
@export_range(0.0, 1.0) var alignment_weight: float = 0.5
@export_range(0.0, 1.0) var cohesion_weight: float = 0.5
@export var max_force: float = 5.0

@export_category("Visualization")
@export_group("FOV")
@export_range(0, 255) var fov_opacity: int = 50
