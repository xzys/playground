class_name Conversation

var data: Array[Dictionary]

static func load_from_file(filename: String):
	# load conversation
	var file = File.new()
	assert(file.file_exists(filename))
	file.open(filename, File.READ)
	var c := Conversation.new()
	c.data = JSON.parse_string(file.get_as_text())
	return c
	
func start(npc: Character, player: Character):
	await play(npc, player, data)

# player should be Player, but runing into cyclic reference problem
# fixed with https://github.com/godotengine/godot/pull/65664
func play(npc: Character, player: Character, data: Array):
	for d in data:
		if d.has('dialogue'):
			npc.speech_bubble.say(d.dialogue)
			await player.continue_conversation
			npc.speech_bubble.clear()
		elif d.has('response'):
			player.speech_bubble.say(d.response)
			await player.continue_conversation
			player.speech_bubble.clear()
		elif d.has('condition'):
			if d.condition.has('player_has'):
				var passed := false
				if d.condition.player_has.has('item'):
					passed = player.inventory.has_item(d.condition.player_has.item)
				else:
					assert(false, 'unimplemented condition')
				
				if passed:
					await play(npc, player, d['then'])
				else:
					await play(npc, player, d['else'])
			else:
				assert(false, 'unimplemented condition')
		elif d.has('give_item'):
			var item = load(d.give_item)
			assert(item is InventoryItem)
			player.inventory.add_item(item)
		else:
			assert(false, 'unimplemented converstaion line')
