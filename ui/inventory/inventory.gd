extends Control

@onready
var player = get_node('../../player')

var open = true

func _ready():
	player.toggle_inventory.connect(_on_toggle_inventory)
	_on_toggle_inventory()
	

func _on_toggle_inventory():
	open = !open
	$InventoryClosed.visible = !open
	$InventoryOpen.visible = open
