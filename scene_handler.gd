extends Node

@onready var main_menu = $MainMenu as Control
var game_scene: PackedScene = preload("res://scenes/MainScenes/game_scene.tscn")


func _ready():
  main_menu.new_game.connect(start_game)
  main_menu.exit_game.connect(end_game)

func start_game():
  main_menu.queue_free()
  var start_game_scene = game_scene.instantiate()
  add_child(start_game_scene)

func end_game():
  get_tree().quit()
