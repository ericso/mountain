extends Node2D
class_name Floor

# UNIT_SIZE is the size in pixes of a single width or heigh unit.
# A single story floor is 1 UINT_SIZE high.
# A shop could be 2 UNIT_SIZE wide.
const UNIT_SIZE: int = 64

@onready var rooms: TileMapLayer = $Rooms

# area_size_tiles (x coordinate is how many spaces wide, y coordinate is how many spaces high)
@export var area_size_tiles: Vector2i = Vector2i(6, 2)

# area_offset_tiles x and y coordinates offset from 0, 0 as tiles (not pixels)
@export var area_offset_tiles: Vector2i = Vector2i.ZERO

@export var layer            : int      = 0          # which TileMap layer to paint
@export var source_id        : int      = 0          # tile source in the TileSet
@export var atlas_coord      : Vector2i = Vector2i.ZERO

@export var debug_color: Color = Color(0.2, 1.0, 0.2, 0.25)

func _init(offset_tiles := Vector2i.ZERO):
	pass

func _enter_tree() -> void:
	pass

func _ready() -> void:
	set_process(false)
	queue_redraw()

func _draw() -> void:
	print("DEBUG: _draw::area_offset_tiles: " + str(area_offset_tiles))
	
	var tl_px := rooms.map_to_local(area_offset_tiles)
	var br_px := rooms.map_to_local(area_offset_tiles + area_size_tiles)
	print("DEBUG: _draw::tl_px: " + str(tl_px))
	print("DEBUG: _draw::br_px: " + str(br_px))
	
	draw_rect(Rect2(tl_px, br_px - tl_px), debug_color)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		stamp_at_global(event.position)

# ─────────────────────────────────────────────────────────────

func stamp_at_global(global_mouse: Vector2) -> void:
	# 1) Mouse to this Floor’s local space
	var local_mouse := to_local(global_mouse)
	# 2) Local px → cell in the TileMap grid
	var cell := rooms.local_to_map(rooms.to_local(local_mouse))
	
	# outside this floor’s rectangle
	if not _cell_in_bounds(cell):
		return

	rooms.set_cell(cell, source_id, atlas_coord)

# ─────────────────────────────────────────────────────────────
# PRIVATE HELPERS
func _cell_in_bounds(cell: Vector2i) -> bool:
	var min_c := area_offset_tiles
	var max_c := area_offset_tiles + area_size_tiles   # exclusive upper bound
	return cell.x >= min_c.x and cell.y >= min_c.y \
		and cell.x <  max_c.x and cell.y <  max_c.y
