extends Character
class_name NPC

@export var character_name := ""
@export var conversation_filename := ""

@onready var floating_label := $FloatingLabel
@onready var player: Character = get_node('/root/Game/Player')

var conversation: Conversation

func _ready():
	conversation = Conversation.load_from_file(conversation_filename)
	floating_label.set_text(character_name, 'X to talk')

func can_start_conversation():
	floating_label.can_interact = conversation != null and player.inventory.has_item('echo')
	return floating_label.can_interact

func start_conversation(player: Character):
	super.start_converstaion(player)
	floating_label.hide_label()
	await conversation.start(self, player)
	end_conversation()
	floating_label.show_label()
