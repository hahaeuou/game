extends Camera2D

var rot_velocity: float
const CAMERA_ROT_MULT = 0.2

func rot_vel_to_camera_rot(rot_vel: float) -> float:
	return (2 / (1 + exp(-rot_vel))) - 1 # transformed logistic function

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var before_lerp = rot_vel_to_camera_rot(rot_velocity) * CAMERA_ROT_MULT
	set_deferred("rotation", lerp(rotation, before_lerp, 0.3))
