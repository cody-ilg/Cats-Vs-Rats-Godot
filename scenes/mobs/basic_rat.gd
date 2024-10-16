extends PathFollow2D

@export var speed: int = 150
@export var hp: int = 50

@onready var health_bar = get_node("HealthBar")

func _ready():
  health_bar.max_value = hp
  health_bar.value = hp
  get_node("HealthBar").set_as_top_level(true)



func _process(delta):
  move(delta)

func move(delta):
  set_progress(get_progress() + speed * delta)
  health_bar.position = position - Vector2(16, 30)

func on_hit(damage):
  hp -= damage
  health_bar.value = hp
  if hp <= 0:
    on_destroy()

func on_destroy():
  self.queue_free()