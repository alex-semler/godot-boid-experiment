class_name Boid
extends Area2D

@export var settings: SimulationSettings

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $FieldOfView
@onready var perception_radius: int = collision_shape.shape.radius
@onready var viewport_size: Vector2 = get_viewport_rect().size

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	velocity = Vector2.from_angle(randf() * TAU) * settings.initial_speed
	sprite.play("flying")
	
func _process(delta: float) -> void:
	var acceleration: Vector2 = get_combined_forces()
	velocity += acceleration * delta
	var speed: float = velocity.length()
	var normalized_speed: float = clamp(speed, settings.speed_range.x, settings.speed_range.y)
	var direction: Vector2 = velocity.normalized()
	velocity = direction * normalized_speed
	
	position += (velocity * delta)
	position.x = fposmod(position.x, viewport_size.x)
	position.y = fposmod(position.y, viewport_size.y)
	rotation = velocity.angle() + PI/2
	
func get_combined_forces() -> Vector2:
	var neighbors: Array = get_neighbors()
	var n_positions: PackedVector2Array = PackedVector2Array()
	var n_velocities: PackedVector2Array = PackedVector2Array()
	for n in neighbors:
		n_positions.append(n.global_position)
		n_velocities.append(n.velocity)
	
	var separation: Vector2 = separation_force(n_positions)
	var alignment: Vector2 = alignment_force(n_velocities)
	var cohesion: Vector2 = cohesion_force(n_positions)
	
	return (separation + alignment + cohesion) * perception_radius
	
func get_neighbors() -> Array[Boid]:
	var within_range: Array[Area2D] = get_overlapping_areas()
	var visible_neighbors: Array[Boid] = []
	for i in range(within_range.size()):
		var neighbor: Boid = within_range[i]
		var angle = abs(velocity.angle() - neighbor.velocity.angle())
		if rad_to_deg(angle) <= settings.fov_angle:
			visible_neighbors.append(neighbor)
	return visible_neighbors
	
func separation_force(neighbor_positions: PackedVector2Array) -> Vector2:
	var force: Vector2 = Vector2.ZERO
	for p: Vector2 in neighbor_positions:
		if p == global_position:
			continue
		var distance: float = global_position.distance_to(p) / perception_radius
		var force_component: Vector2 = (p - global_position).normalized() / (distance * distance)
		force -= force_component
	return steer_towards(force) * settings.separation_weight
	
func alignment_force(neighbor_velocities: PackedVector2Array) -> Vector2:
	var average_velocity: Vector2 = average_vectors(neighbor_velocities)
	return steer_towards(average_velocity) * settings.alignment_weight
	
func cohesion_force(neighbor_positions: PackedVector2Array) -> Vector2:
	var center_of_mass: Vector2 = average_vectors(neighbor_positions)
	return steer_towards(center_of_mass - global_position) * settings.cohesion_weight
	
func average_vectors(vectors: Array[Vector2]) -> Vector2:
	if vectors.is_empty():
		return Vector2.ZERO
	var sum: Vector2 = vectors.reduce(func(acc, v): return acc + v, Vector2.ZERO)
	return sum / vectors.size()
		
func steer_towards(target: Vector2) -> Vector2:
	var steering_motion: Vector2 = target.normalized() * settings.speed_range.x - velocity
	return steering_motion.limit_length(settings.max_force)
