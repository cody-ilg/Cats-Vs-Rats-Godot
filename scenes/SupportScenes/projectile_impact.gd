extends AnimatedSprite2D

func _ready():
  is_playing()


func _on_animation_finished():
  queue_free()
