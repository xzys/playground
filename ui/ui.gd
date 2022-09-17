extends MarginContainer

@onready var inventory := $Inventory

# handle when items are dropped outside of inventory
func _can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func _drop_data(_position, data):
	print('drop', data)
	inventory.set_item(data.item_index, data.item)
