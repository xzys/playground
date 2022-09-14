extends GridContainer

@onready var inventory = get_node('/root/Game/UI/Inventory')

func _ready():
	inventory.items_changed.connect(_on_items_changed)
	# inventory.make_items_unique()
	update_inventory_display()

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var slot_display = get_child(item_index)
	var item = inventory.items[item_index]
	slot_display.display_item(item)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
