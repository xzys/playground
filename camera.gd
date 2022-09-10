extends Camera3D


var player
var initial_transform
var screensize

func _ready():
	look_at(Vector3.ZERO, Vector3.UP)
	player = get_node('../player')
	initial_transform = global_transform.origin
	screensize = get_viewport().get_visible_rect().size


func _process(delta):
	var pos = player.global_transform.origin
	var camera_pos = pos + initial_transform
	look_at_from_position(camera_pos, pos, Vector3.UP)

#	var projection = unproject_position(pos)
#	print('project', projection)
