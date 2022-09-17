extends Node3D
class_name SpeechBubble

@onready var canvas: CanvasLayer = get_node('/root/Game/LabelCanvas')
@onready var camera: Camera3D = get_node('/root/Game/Camera')
var theme = preload('res://ui/theme.tres')

class SpeechTriangle:
	extends Node2D

	func _draw():
		var p = PackedVector2Array([
			Vector2(0, 30),
			Vector2(20, -10),
			Vector2(-20, -10)])
		draw_colored_polygon(p, Color(255, 255, 255, 1))


var speech_label := Label.new()
var speech_label_visible := false
var speech_label_offset := Vector2.ZERO
var triangle := SpeechTriangle.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	speech_label.set_theme(theme)
	speech_label.set_theme_type_variation("SpeechLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if speech_label_visible:		
		var pos = camera.unproject_position(global_position)
		speech_label.position = pos + speech_label_offset
		triangle.position = pos
	set_process(false)

func say(text):
	speech_label.set_text(text)
	speech_label_visible = true
	canvas.add_child(triangle)
	canvas.add_child(speech_label)
	# https://godotengine.org/qa/11957/how-can-set-label-to-change-size-according-the-length-the-text
	# hack to set size if string is smaller than before
	speech_label.size = speech_label.get_theme_default_font().get_string_size(text)
	speech_label_offset = -1 * speech_label.get_size()/2
	set_process(true)

func clear():
	speech_label_visible = false
	canvas.remove_child(triangle)
	canvas.remove_child(speech_label)
