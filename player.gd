extends Character

@onready var area: Area3D = $NearbyArea

signal toggle_inventory()


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_node("FloatingLabel"):
		body.floating_label.show_label()

func _on_body_exited(body):
	if body.has_node("FloatingLabel"):
		body.floating_label.hide_label()


func handle_controls():
	if Input.is_action_just_pressed("toggle_inventory"):
		emit_signal("toggle_inventory")

	if Input.is_action_just_pressed('interact'):
		var bodies = area.get_overlapping_bodies()
		for b in bodies:
			if b is StaticItem:
				b.pick_up()
			elif b is NPC and b.can_start_conversation():
				b.start_conversation(self)

func get_movement() -> Vector3:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = ((transform.basis * Vector3(input_dir.x, 0, input_dir.y))
		.rotated(Vector3.UP, -PI/4).normalized())

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		direction.y = 1
	return direction
