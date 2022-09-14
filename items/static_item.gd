extends StaticBody3D
class_name StaticItem

@export var inventory_item: Resource

func _ready():
	assert(inventory_item is InventoryItem)
