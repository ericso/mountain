extends Node2D

var floor_scene := preload("res://Floor.tscn")

func _ready() -> void:
	spawn_floor(Vector2i(0, 12))

func spawn_floor(offset_tiles : Vector2i) -> void:
	var new_floor := floor_scene.instantiate() as Floor
	new_floor.area_offset_tiles = offset_tiles
	add_child(new_floor)
