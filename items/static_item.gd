extends StaticBody3D
class_name StaticItem

@export var inventory_item: Resource

@onready var inventory = get_node('/root/Game/UI/Inventory')
@onready var level = get_node('/root/Game/Level')
@onready var floating_label := $FloatingLabel as FloatingLabel

func _ready():
	assert(inventory_item is InventoryItem)
	floating_label.set_text(inventory_item.name, 'X to pick up')

func pick_up():
	if inventory.add_item(inventory_item):
		level.remove_child(self)
