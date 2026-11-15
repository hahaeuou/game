extends Camera2D

var rot_velocity: float
var velocity: float
const CAMERA_ROT_MULT = 0.05
const CAMERA_SCALE_MULT = 0.0001 # very sensitive

func rot_vel_to_camera_rot(rot_vel: float) -> float:
	return ((2 / (1 + exp(-rot_vel))) - 1) * CAMERA_ROT_MULT # transformed logistic function


func vel_to_camera_scale(vel: float) -> float:
	return max(0.6, 1 / (CAMERA_SCALE_MULT * vel + 1))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var before_lerp_rot = rot_vel_to_camera_rot(rot_velocity)
	var before_lerp_scale = vel_to_camera_scale(velocity)
	set_deferred("rotation", lerp(rotation, before_lerp_rot, 0.3))
	set_deferred("zoom", lerp(zoom, Vector2.ONE * before_lerp_scale, 0.3))
	print(zoom)
