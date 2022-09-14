extends Node3D


var rock = preload('res://items/rock.tscn')

func _ready():
	var r = rock.instantiate()
	r.transform.origin.x = 1
	r.transform.origin.z = 1
	add_child(r)
