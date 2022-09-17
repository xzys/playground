extends Control

@onready var player = get_node('/root/Game/Player')

@export var num_items: int = 16

var open = true
var items: Array = []
var drag_data


signal items_changed(indexes)

func _ready():
	player.toggle_inventory.connect(_on_toggle_inventory)
	_on_toggle_inventory()
	
	var per_side = sqrt(num_items)
	assert(per_side == floor(per_side))
	# create empty items
	items.resize(num_items)
	

func _on_toggle_inventory():
	open = !open
	$InventoryClosed.visible = !open
	$InventoryOpen.visible = open

func add_item(item: InventoryItem) -> bool:
	for index in range(len(items)):
		if items[index] == null:
			set_item(index, item)
			return true
		elif items[index].name == item.name:
			items[index].amount += 1
			emit_signal("items_changed", [index])
			return true
	return false

func has_item(name: String):
	for item in items:
		if item != null and item.name == name:
			return true
	return false

func set_item(item_index: int, item: InventoryItem):
	var prev = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return prev

func swap_items(item_index: int, target_item_index: int):
	var target = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = target
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item_index: int):
	var prev = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return prev
