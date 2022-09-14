extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 0.3

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var model = get_node('Model')

signal toggle_inventory()

func handle_controls():
	if Input.is_action_just_pressed("toggle_inventory"):
		emit_signal("toggle_inventory")


func handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = ((transform.basis * Vector3(input_dir.x, 0, input_dir.y))
		.rotated(Vector3.UP, -PI/4).normalized())
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		# rotate model
		model.rotation.y = lerp_angle(model.rotation.y, -input_dir.angle()+PI/4, ROTATION_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _physics_process(delta):
	handle_controls()
	handle_movement(delta)
