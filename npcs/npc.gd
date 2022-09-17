extends Character
class_name NPC


@export var character_name := ""
@export var conversation_filename := ""

@onready var floating_label := $FloatingLabel
@onready var speech_bubble := $SpeechBubble

var conversation: Array[Dictionary]

func _ready():
	# load conversation
	var file = File.new()
	assert(file.file_exists(conversation_filename))
	file.open(conversation_filename, File.READ)
	conversation = JSON.parse_string(file.get_as_text())
	conversation = conversation[0]['else']

	floating_label.set_text(character_name, 'X to talk')
	floating_label.can_interact = can_start_conversation()
	print(conversation)


func can_start_conversation():
	# TOOD make sure player has echo
	return conversation != null

func start_conversation(other: Character):
	super.start_converstaion(other)
	floating_label.hide_label()
	speech_bubble.say(conversation[0].dialogue)
