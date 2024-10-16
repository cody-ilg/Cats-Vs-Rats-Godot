extends Node2D


var map_node

var build_mode: bool = false
var build_valid: bool = false
var build_tile
var build_location
var build_type
var current_wave: int = 0
var mobs_in_wave: int = 0

func _ready():
  map_node = get_node("Level1") #turn this into var based on selected map

  for i in get_tree().get_nodes_in_group("build_buttons"):
    i.pressed.connect(initiate_build_mode.bind(i.name))


func _process(_delta):
  if build_mode:
    update_tower_preview()

func _unhandled_input(event):
  if event.is_action_released("ui_cancel") and build_mode == true:
    cancel_build_mode()
  if event.is_action_released("ui_accept") and build_mode == true:
    verify_and_build()
    cancel_build_mode()


## Building functions

func initiate_build_mode(tower_type):
  if build_mode:
    cancel_build_mode()
  build_type = tower_type + "T1"
  build_mode = true 
  get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
  var mouse_position = get_global_mouse_position()
  var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
  var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)

	
  if map_node.get_node("TowerExclusion").get_cell_source_id(0, current_tile) == -1:
    get_node("UI").update_tower_preview(tile_position, "4287f5")
    build_valid = true 
    build_location = tile_position
    build_tile = current_tile
	
  else:
    get_node("UI").update_tower_preview(tile_position, "f54242")
    build_valid = false

func cancel_build_mode():
  build_mode = false
  build_valid = false
  get_node("UI/TowerPreview").free()

func verify_and_build():
  if build_valid:
    var new_tower = load("res://scenes/towers/" + build_type + ".tscn").instantiate()
    new_tower.position = build_location
    new_tower.built = true
    new_tower.type = str(build_type)
    new_tower.category = GameData.tower_data[build_type]["category"]
    map_node.get_node("Turrets").add_child(new_tower, true)
    map_node.get_node("TowerExclusion").set_cell(0, build_tile, 5, Vector2(1,0))

## Wave Functions

func start_next_wave():
  var wave_data = retrieve_wave_data()
  await(get_tree().create_timer(0.2).timeout)
  spawn_mobs(wave_data)

func retrieve_wave_data():
  var wave_data = [["basic_rat", 0.7], ["basic_rat", 0.7], ["basic_rat", 0.7], ["basic_rat", 0.7], ["basic_rat", 0.7], ["basic_rat", 0.7], ["basic_rat", 0.7], ["basic_rat", 0.7], ]
  current_wave += 1
  mobs_in_wave = wave_data.size()
  return wave_data

func spawn_mobs(wave_data):
  for i in wave_data:
    var new_mob = load("res://scenes/mobs/" + i[0] + ".tscn").instantiate()
    map_node.get_node("MobPath").add_child(new_mob, true)
    await(get_tree().create_timer(i[1]).timeout)

