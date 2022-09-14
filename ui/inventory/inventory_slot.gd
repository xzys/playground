extends CenterContainer

@onready var inventory = get_node('/root/Game/UI/Inventory')
@onready var item_texture = $TextureRect
@onready var item_amount_label = $Label

var custom_size = 30

func display_item(item):
	if item is InventoryItem:
		item_texture.texture = item.texture
		item_amount_label.text = str(item.amount) if item.amount > 1 else ''
	else:
		item_texture.texture = null
		item_amount_label.text = ''

func _get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is InventoryItem:
		var data = {}
		data.item = item
		data.item_index = item_index
		# create preview
		var drag_preview = TextureRect.new()
		drag_preview.ignore_texture_size = true
		drag_preview.custom_minimum_size = Vector2(custom_size, custom_size)
		drag_preview.texture = item.texture
		set_drag_preview(drag_preview)
		inventory.drag_data = data
		return data

func _can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func _drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is InventoryItem and my_item.name == data.item.name:
		my_item.amount += data.item.amount
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null
