extends CanvasLayer

@onready var hp_bar = get_node("HUD/InfoBar/MarginContainer/HBoxContainer/HPBar")


func set_tower_preview(tower_type, mouse_position):
  var drag_tower = load("res://scenes/towers/" + tower_type + ".tscn").instantiate()
  drag_tower.set_name("DragTower")
  drag_tower.modulate = Color("329ea8")

  var range_texture = Sprite2D.new()
  range_texture.position = Vector2(0, 0)
  var scaling = GameData.tower_data[tower_type]["range"] / 445.0
  range_texture.scale = Vector2(scaling, scaling)
  var texture = load("res://assets/towers/range_01.png")
  range_texture.texture = texture
  range_texture.modulate = Color("329ea8")

  
  var control = Control.new()
  control.add_child(drag_tower, true)
  control.add_child(range_texture, true)
  control.set_position(mouse_position)
  control.set_name("TowerPreview")
  add_child(control, true)
  move_child(get_node("TowerPreview"), 0)

func update_tower_preview(new_position, color):
  get_node("TowerPreview").set_position(new_position)
  if get_node("TowerPreview/DragTower").modulate != Color(color):
    get_node("TowerPreview/DragTower").modulate = Color(color)
    get_node("TowerPreview/Sprite2D").modulate = Color(color)


## Game control functions

func _on_pause_play_pressed():
  if get_parent().build_mode:
    get_parent().cancel_build_mode()
  if get_tree().is_paused():
    get_tree().paused = false
  elif get_parent().current_wave == 0:
    get_parent().current_wave += 1
    get_parent().start_next_wave()
  else:
    get_tree().paused = true

func _on_fast_forward_pressed():
  if Engine.get_time_scale() == 2.0:
    Engine.set_time_scale(1.0)
  else:
    Engine.set_time_scale(2.0)

## Health bar

func update_health_bar(player_health):
  var hp_bar_tween = hp_bar.create_tween()
  hp_bar_tween.tween_property(hp_bar, "value", player_health, 0.1)
