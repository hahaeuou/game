extends RigidBody2D

var force_mult = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("left arrow"):
		apply_central_force(Vector2.LEFT * force_mult)
	if Input.is_action_pressed("right arrow"):
		apply_central_force(Vector2.RIGHT * force_mult)
	if Input.is_action_just_pressed("up arrow"):
		pass
	if Input.is_action_just_pressed("down arrow"):
		apply_central_impulse(Vector2.DOWN * force_mult)
	$Camera2D.rot_velocity = angular_velocity
	$Camera2D.velocity = linear_velocity.length()
