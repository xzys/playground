extends Node3D
class_name FloatingLabel

@export var custom_offset: Vector2

@onready var canvas: CanvasLayer = get_node('/root/Game/LabelCanvas')
@onready var camera: Camera3D = get_node('/root/Game/Camera')
var theme = preload('res://ui/theme.tres')

var label: Label = Label.new()
var label_visible: bool = false
var label_offset: Vector2

var can_interact: bool = true
var action_label: Label = Label.new()
var action_label_visible: bool = false
var action_label_offset: Vector2


func _ready():
	label.set_theme(theme)
	action_label.set_theme(theme)

func set_text(label_text, action_label_text):
	label.text = label_text
	action_label.text = action_label_text

# NOTE: using _physics_process makes text delay when layer moves
var pos: Vector2
var mult: Vector2
func _process(delta):
	if label_visible || action_label_visible:
		pos = camera.unproject_position(global_position)
		mult.x = 1 if pos.x > camera.screensize.x / 2 else -1
		mult.y = 1 if pos.y > camera.screensize.y / 2 else -1

		if label_visible:
			label.position = pos + label_offset + Vector2(0, mult.y * custom_offset.y)
		if action_label_visible:
			action_label.position = (pos + action_label_offset +
				Vector2(mult.x * (-action_label_offset.x + custom_offset.x), 0))

func show_label():
	label_visible = true
	canvas.add_child(label)
	# can't get label size untils it's on scene
	label_offset = -1 * label.get_size()/2

	if can_interact:
		action_label_visible = true
		canvas.add_child(action_label)
		action_label_offset = -1 * action_label.get_size()/2

func hide_label():
	label_visible = false
	canvas.remove_child(label)

	if can_interact:
		action_label_visible = false
		canvas.remove_child(action_label)
