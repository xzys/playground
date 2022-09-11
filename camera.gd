extends Camera3D

@onready
var player = get_node('../player')
var intial_pos
var screensize

func _ready():
	look_at(Vector3.ZERO, Vector3.UP)
	intial_pos = global_transform.origin
	screensize = get_viewport().get_visible_rect().size


func _process(delta):
	var pos = player.global_transform.origin
	var camera_pos = pos + intial_pos
	look_at_from_position(camera_pos, pos, Vector3.UP)
