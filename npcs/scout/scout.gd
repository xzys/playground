extends NPC

func _ready():
	super._ready()
	player.area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body == self and not player.inventory.has_item('echo'):
		start_conversation(player)
		# player.area.body_entered.disconnect(_on_body_entered)
