extends CharacterBody3D
class_name Character

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 0.3

@onready var model = $Model

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# move out to common class for both NPC and character
var is_talking := false
var is_talking_to: Character

func handle_controls():
	pass

func get_movement() -> Vector3:
	return Vector3.ZERO
	
func start_converstaion(other: Character):
	is_talking = true
	is_talking_to = other
	other.is_talking = true
	other.is_talking_to = self

func handle_movement(delta):
	var direction := Vector3.ZERO
	if is_talking:
		var facing = is_talking_to.global_position - global_position
		model.rotation.y = lerp_angle(model.rotation.y, atan2(facing.x, facing.z), ROTATION_SPEED)
	else:
		direction = get_movement()
	
	if direction.y:
		velocity.y = JUMP_VELOCITY
	if direction.x || direction.z:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# rotate model
		model.rotation.y = lerp_angle(model.rotation.y, atan2(direction.x, direction.z), ROTATION_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
#
func _physics_process(delta):
	handle_controls()
	handle_movement(delta)
	move_and_slide()
