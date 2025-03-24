extends PathFollow2D

# signal reached_end(damage)

@export var speed: int = 150
@export var hp: int = 50
@export var player_damage: int = 1

@onready var health_bar = get_node("HealthBar")
@onready var impact_area = get_node("ImpactPos")
var projectile_impact = preload("res://scenes/SupportScenes/projectile_impact.tscn")

func _ready():
  health_bar.max_value = hp
  health_bar.value = hp
  get_node("HealthBar").set_as_top_level(true)



func _process(delta):
  if progress == 1.0:
    # emit_signal("reached_end", player_damage)
    queue_free()
  move(delta)

func move(delta):
  set_progress(get_progress() + speed * delta)
  health_bar.position = position - Vector2(16, 30 )

func on_hit(damage):
  get_node("CharacterBody2D/AnimationPlayer").play("hit")
  impact()
  hp -= damage
  health_bar.value = hp
  if hp <= 0:
    on_destroy()

func impact():
  randomize()
  var x_pos = randi() % 31
  randomize()
  var y_pos = randi() % 31
  var impact_pos = Vector2(x_pos, y_pos)
  var new_impact = projectile_impact.instantiate()
  new_impact.position = impact_pos
  impact_area.add_child(new_impact)

func on_destroy():
  self.queue_free()