extends Node2D

@export var settings: SimulationSettings

@onready var boid: Boid = $"../.."
@onready var field_of_view: CollisionShape2D = $"../../FieldOfView"

func _draw():
	var angle: float = deg_to_rad(settings.fov_angle)
	var radius: int = field_of_view.shape.radius
	var opacity: int = settings.fov_opacity
	draw_arc(
	position, 
	radius, 
	- (angle + PI) / 2, 
	(angle - PI) / 2, 
	20,
	Color.from_rgba8(0, 0, 0, opacity)
)
	
func _process(_delta: float):
	queue_redraw()
