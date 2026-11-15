extends RigidBody2D

var force_mult = 30
var state = REST
var high_speed_collision: bool

enum {REST, IDLE, HURT, DIZZY, HAPPY}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if state == REST:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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
	$Sprite2D.flip_h = max(0, sign(linear_velocity.x))


func _on_body_entered(body: Node) -> void:
		high_speed_collision = true
		
