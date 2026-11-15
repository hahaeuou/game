extends RigidBody2D

var force_mult = 30
var state = REST
var high_speed_collision = false
var high_ang_vel = false
var time_to_idle: float

enum {REST, IDLE, HURT, DIZZY, HAPPY}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	time_to_idle = $Timer.time_left
	high_ang_vel = abs(angular_velocity) > 12
	if high_speed_collision:
		state = HURT
	elif high_ang_vel:
		state = DIZZY
	elif time_to_idle > 0:
		state = REST
	print(time_to_idle)
	if state == REST:
		$Sprite2D.texture = preload("res://player_rest.png")
	if state == IDLE:
		$Sprite2D.texture = preload("res://player_idle.png")
	if state == HURT:
		$Sprite2D.texture = preload("res://player_hurt.png")
	if state == DIZZY:
		$Sprite2D.texture = preload("res://player_dizzy.png")
	if state == HAPPY:
		$Sprite2D.texture = preload("res://player_happy.png")
	print(state)
	

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
	if Input.is_anything_pressed():
		$Timer.start()
	$Camera2D.rot_velocity = angular_velocity
	$Camera2D.velocity = linear_velocity.length()
	$Sprite2D.flip_h = max(0, sign(linear_velocity.x)) if abs(linear_velocity.x) > 64 else $Sprite2D.flip_h


func _on_body_entered(body: Node) -> void:
	print("entered")
	if linear_velocity.length() > 2048:
		high_speed_collision = true
	await get_tree().create_timer(2.0).timeout
	high_speed_collision = false


func _on_timer_timeout() -> void:
	state = IDLE
