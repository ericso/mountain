extends Node2D
class_name Building

var zoning_mode: bool = false

# CELL_SIZE is the tile size in pixels
const CELL_SIZE: int = 64
# CELL_OFFSET is used to shift from the center of a cell to its top-left coordinate
const CELL_OFFSET: Vector2 = Vector2(CELL_SIZE/2, CELL_SIZE/2)

@onready var zones: TileMapLayer = $Zones

# ------------------------- BUILDING SIZE AND POSITION -------------------------
# building_size represents the dimensions of the building in cells
# x coordinate is how many cells wide the building is
# y coordinate is how many cells high the building is
@export var building_size: Vector2i

# building_position is the cell of the bottom left corner of the building
@export var building_position: Vector2i

# -------------------------- TILE MAP LAYER VARIABLES --------------------------
# TODO: make the atlas_coord represent which tile you are placing
@export var layer: int = 0 # which TileMap layer to paint
@export var source_id: int = 0 # tile source in the TileSet
@export var atlas_coord: Vector2i = Vector2i.ZERO # which tile in atlas

# TODO: create a background image representing the new floor
@export var debug_color: Color = Color(1.2, 1.0, 0.2, 0.25)
# ------------------------------------------------------------------------------

func _on_place_floor_button_pressed() -> void:
	zoning_mode = !zoning_mode

func _draw() -> void:
	Global.debug_print("Building nbode pos", str(position))
	Global.debug_print("Zones node pos", str(zones.position))
	Global.debug_print("building_position", str(building_position))
	Global.debug_print("building_size", str(building_size))
	
	var top_left_cell := building_position
	top_left_cell.y -= building_size.y - 1  # adjust from bottom-left to top-left
	
	# the offset applied Vector2i(0, 6) accounts for the y offset - TODO figure out what is causing this offset
	var top_left_px := zones.map_to_local(building_position + Vector2i(0, 6)) - CELL_OFFSET
	var size_px := Vector2(building_size.x, building_size.y) * CELL_SIZE
	
	Global.debug_print("_draw::top_left_px", str(top_left_px))
	Global.debug_print("_draw::size_px", str(size_px))
	draw_rect(Rect2(top_left_px, size_px), debug_color)
	
	# TODO TESTING ----------
	var test_cell := Vector2i(0, 6) # this rectangle appears at 0,0 (there's a 6 cell offset for some reason)
	var test_px := zones.map_to_local(test_cell)
	# Draw a red 64x64 rect at (0,0) cell
	draw_rect(Rect2(test_px, Vector2(CELL_SIZE, CELL_SIZE)), Color.RED)
	Global.debug_print("Tile (1, 1) maps to px:", str(test_px))
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		stamp_at_global(event.position)

# _cell_in_bounds checks that the given cell is within the building
func _cell_in_bounds(cell: Vector2i) -> bool:
	var min_c := building_position
	var max_c := building_position + building_size
	#var min_c := zones.map_to_local(building_position)
	#var max_c := zones.map_to_local(building_position + building_size)
	Global.debug_print("_cell_in_bounds::min_c", str(min_c))
	Global.debug_print("_cell_in_bounds::max_c", str(max_c))
	return cell.x >= min_c.x \
		and cell.y >= min_c.y \
		and cell.x <  max_c.x \
		and cell.y <  max_c.y

func stamp_at_global(global_mouse: Vector2) -> void:
	var local_mouse := zones.to_local(global_mouse)
	var cell := zones.local_to_map(local_mouse)
	
	# Optional: visualize where this cell is
	var px := zones.map_to_local(cell)
	Global.debug_print("Clicked cell:", str(cell))
	Global.debug_print("Cell top-left px:", str(px))
	
	# outside this floor’s rectangle
	if not _cell_in_bounds(cell):
		Global.debug_print("stamp_at_global::not _cell_in_bounds", str(cell))
		return

	# the offset applied Vector2i(0, 6) accounts for the y offset - TODO figure out what is causing this offset
	zones.set_cell(cell + Vector2i(0, 6), source_id, atlas_coord)
