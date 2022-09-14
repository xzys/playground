extends Control

@onready var player = get_node('/root/Game/Player')

@export var num_items: int = 16

var open = true
var items: Array = []
var drag_data


signal items_changed(indexes)

var rock = preload("res://items/rock.tres")

func _ready():
	player.toggle_inventory.connect(_on_toggle_inventory)
	_on_toggle_inventory()
	
	var per_side = sqrt(num_items)
	assert(per_side == floor(per_side))
	# create empty items
	items.resize(num_items)
	set_item(0, rock)
	set_item(1, rock)
	print(items)
	

func _on_toggle_inventory():
	open = !open
	$InventoryClosed.visible = !open
	$InventoryOpen.visible = open

func set_item(item_index, item):
	assert(item is InventoryItem)
	var prev = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return prev

func swap_items(item_index, target_item_index):
	var target = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = target
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item_index):
	var prev = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return prev
