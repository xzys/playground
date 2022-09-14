extends StaticBody3D
class_name StaticItem

@export var inventory_item: Resource
@export var custom_offset: Vector2

@onready var camera: Camera3D = get_node('/root/Game/Camera')
@onready var canvas: CanvasLayer = get_node('/root/Game/LabelCanvas')
@onready var inventory = get_node('/root/Game/UI/Inventory')
@onready var level = get_node('/root/Game/Level')

var theme = preload('res://ui/theme.tres')

var label_visible: bool = false
var label: Label = Label.new()
var label_offset: Vector2
var action_label: Label = Label.new()
var action_label_offset: Vector2


func _ready():
	assert(inventory_item is InventoryItem)
	label.text = inventory_item.name
	label.set_theme(theme)
	action_label.text = 'X to pick up'
	action_label.set_theme(theme)

func pick_up():
	if inventory.add_item(inventory_item):
		level.remove_child(self)

# NOTE: using _physics_process makes text delay movement behind player
var pos: Vector2
var mult: Vector2
func _process(delta):
	if label_visible:
		pos = camera.unproject_position(global_transform.origin)
		mult.x = 1 if pos.x > camera.screensize.x / 2 else -1
		mult.y = 1 if pos.y > camera.screensize.y / 2 else -1
		label.position = pos + label_offset + Vector2(0, mult.y * custom_offset.y)
		action_label.position = (pos + action_label_offset +
			Vector2(mult.x * (-action_label_offset.x + custom_offset.x), 0))

func show_label():
	label_visible = true
	canvas.add_child(label)
	canvas.add_child(action_label)
	# can't get label size untils it's on scene
	label_offset = -1 * label.get_size()/2
	action_label_offset = -1 * action_label.get_size()/2
	
func hide_label():
	label_visible = false
	canvas.remove_child(label)
	canvas.remove_child(action_label)
