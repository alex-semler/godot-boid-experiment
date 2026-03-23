class_name Boid
extends Area2D

@export var speed: int = 200

var velocity: Vector2 = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $FieldOfView
@onready var perception_radius: int = collision_shape.shape.radius
@onready var viewport_size: Vector2 = get_viewport_rect().size

@export_range(0, 360) var FOV: int = 120
@export var MAX_FORCE: float = 5.0
@export_range(0.0, 1.0) var SEPARATION_WEIGHT: float = 0.5
@export_range(0.0, 1.0) var ALIGNMENT_WEIGHT: float = 0.5
@export_range(0.0, 1.0) var COHESION_WEIGHT: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2.from_angle(randf() * TAU) * speed
	sprite.play("flying")
	
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
	
	return separation + alignment + cohesion
	
func get_neighbors() -> Array[Boid]:
	var within_range: Array[Area2D] = get_overlapping_areas()
	var visible_neighbors: Array[Boid] = []
	for i in range(within_range.size()):
		var neighbor: Boid = within_range[i]
		var angle = abs(velocity.angle() - neighbor.velocity.angle())
		if rad_to_deg(angle) <= FOV:
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
	return force.limit_length(SEPARATION_WEIGHT * MAX_FORCE)
	
func alignment_force(neighbor_velocities: PackedVector2Array) -> Vector2:
	if neighbor_velocities.is_empty():
		return Vector2.ZERO
	var sum: Vector2 = Vector2.ZERO
	for v: Vector2 in neighbor_velocities:
		sum += v
	return (sum / len(neighbor_velocities)).limit_length(ALIGNMENT_WEIGHT * MAX_FORCE)
	
func cohesion_force(neighbor_positions: PackedVector2Array) -> Vector2:
	if neighbor_positions.is_empty():
		return Vector2.ZERO
	var sum: Vector2 = Vector2.ZERO
	for p: Vector2 in neighbor_positions:
		sum += p
	var average_position: Vector2 = sum / len(neighbor_positions)
	return (average_position - global_position).limit_length(COHESION_WEIGHT * MAX_FORCE)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var combined_forces: Vector2 = get_combined_forces()
	velocity = (velocity + combined_forces).normalized() * speed
	
	position += (velocity * delta)
	position.x = fposmod(position.x, viewport_size.x)
	position.y = fposmod(position.y, viewport_size.y)
	
	rotation = velocity.angle() + PI/2
