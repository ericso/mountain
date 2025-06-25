extends Node2D

@onready var camera: Camera2D = $Camera2D

const CELL_SIZE: int = 64 # tile size in pixels

const BUILDING = preload("res://building.tscn")

const INITIAL_BUILDING_SIZE: Vector2i = Vector2i(6, 1)
const BUILDING_POSITION: Vector2i = Vector2i(2, 15)
	
func _ready() -> void:
	spawn_building(INITIAL_BUILDING_SIZE, BUILDING_POSITION)

func spawn_building(building_size, building_position: Vector2i) -> void:
	var new_building := BUILDING.instantiate() as Building
	new_building.building_position = building_position
	new_building.building_size = building_size
	add_child(new_building)
	
	# TODO: this code moves the camera to center on the building
	# This should be refactored to set the camera position in the _ready() function
	var tile_center := new_building.zones.map_to_local(new_building.building_position + new_building.building_size / 2)
	set_camera(tile_center)

func set_camera(pos: Vector2) -> void:
	camera.position = pos
