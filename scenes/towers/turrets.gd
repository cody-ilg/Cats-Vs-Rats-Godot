extends Node2D
class_name Turrets

var type
var category: String
var mob_arr = []
var built = false
var mob
var is_ready: bool = true
var range_texture: Sprite2D

func _ready():
  if built:
    self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]
    # range_texture = Sprite2D.new()
    # range_texture.position = Vector2(0, 0)
    # var scaling = GameData.tower_data[type]["range"] / 445
    # range_texture.scale = Vector2(scaling, scaling)
    # var texture = load("res://assets/towers/range_01.png")
    # range_texture.texture = texture
    # range_texture.visible = false
  




func _physics_process(_delta):
  if mob_arr.size() != 0 and built:
    select_mob()
    turn()
    if is_ready:
      fire()
  else:
    mob = null

func turn():
  $Gun.look_at(mob.position)

func select_mob():
  var mob_progress_arr = []
  for i in mob_arr:
    mob_progress_arr.append(i.progress)
  var max_progress = mob_progress_arr.max()
  var mob_index = mob_progress_arr.find(max_progress)
  mob = mob_arr[mob_index]

func fire():
  print("fire")
  is_ready = false
  if category == "projectile":
    fire_gun()
  elif category == "missle":
    fire_missle()
  mob.on_hit(GameData.tower_data[type]["damage"])
  if(mob.hp <= 0):
    mob_arr.erase(mob)
  await (get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
  is_ready = true

func fire_gun():
  get_node("AnimationPlayer").play("fire")

func fire_missle():
  pass


##TARGET ARR

func _on_range_body_exited(body:Node2D):
  mob_arr.erase(body.get_parent())

func _on_range_body_entered(body:Node2D):
  mob_arr.append(body.get_parent())


##MOUSE INTERACTION

# func _on_interact_zone_mouse_exited():
#   range_texture.visible = false


# func _on_interact_zone_mouse_entered():
#   range_texture.visible = true


