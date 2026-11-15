extends RigidBody2D

const force_mult = 9
var state = REST
var high_speed_collision = false
var high_ang_vel = false
var time_to_idle: float
var reset_state = false
var is_on_floor: bool
var is_in_orb = false

var checkpoint_pos = Vector2.ZERO

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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left arrow"):
		apply_central_force(Vector2.LEFT * force_mult / (0.0001 * abs(linear_velocity.x) + 1))
	if Input.is_action_pressed("right arrow"):
		apply_central_force(Vector2.RIGHT * force_mult / (0.0001 * abs(linear_velocity.x) + 1))
	if Input.is_action_just_pressed("up arrow") and is_in_orb:
		apply_central_impulse(Vector2.UP * force_mult * gravity_scale)
	if Input.is_action_just_pressed("down arrow"):
		apply_central_impulse(Vector2.DOWN * force_mult * gravity_scale / (0.0001 * abs(linear_velocity.y) + 1))
	if Input.is_anything_pressed():
		$Timer.start()
	$Camera2D.rot_velocity = angular_velocity
	$Camera2D.velocity = linear_velocity.length()
	$Sprite2D.flip_h = max(0, sign(linear_velocity.x)) if abs(linear_velocity.x) > 64 else $Sprite2D.flip_h


func _on_body_entered(body: Node) -> void:
	is_on_floor = true
	if linear_velocity.length() > 2048:
		high_speed_collision = true
		await get_tree().create_timer(2.0).timeout
		high_speed_collision = false
	await get_tree().create_timer(0.2).timeout
	is_on_floor = false


func _on_timer_timeout() -> void:
	state = IDLE


func _on_checkpoint_detector_area_entered(area: Area2D) -> void:
	checkpoint_pos = position
	area.new_checkpoint_active()


func _on_spike_detector_area_entered(area: Area2D) -> void:
	die()


func die():
	reset_state = true
	await get_tree().create_timer(0.1).timeout
	reset_state = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if reset_state:
		var t = state.get_transform()
		t.origin.x = checkpoint_pos.x
		t.origin.y = checkpoint_pos.y
		state.set_transform(t)


func _on_orb_detector_area_entered(area: Area2D) -> void:
	is_in_orb = true


func _on_orb_detector_area_exited(area: Area2D) -> void:
	is_in_orb = false


func _on_grav_swt_detector_area_entered(area: Area2D) -> void:
	gravity_scale = 1.0 if area.rotation == 0.0 else -1.0


func _on_win_detector_area_entered(area: Area2D) -> void:
	state = HAPPY
