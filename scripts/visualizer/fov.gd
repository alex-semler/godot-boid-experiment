extends Node2D

@onready var boid: Boid = $"../.."
@onready var field_of_view: CollisionShape2D = $"../../FieldOfView"

func _draw():
	var angle = deg_to_rad(boid.FOV)
	var radius: int = field_of_view.shape.radius
	draw_arc(position, radius, - angle / 2 - PI / 2, angle / 2 - PI / 2, 20, Color.from_rgba8(0, 0, 0, 50))
	
func _process(_delta: float):
	queue_redraw()
