extends Node

@onready var main_menu = $MainMenu as Control
var game_scene: PackedScene = preload("res://scenes/MainScenes/game_scene.tscn")


func _ready():
  load_main_menu()

func load_main_menu():
  main_menu.new_game.connect(start_game)
  # main_menu.exit_game.connect(end_game)

func start_game():
  main_menu.queue_free()
  var start_game_scene = game_scene.instantiate()
  # game_scene.connect(game_over, "unload_game")
  add_child(start_game_scene)

func end_game():
  get_tree().quit()

# func unload_game():
#   get_node("game_scene").queue_free()
#   var reset_game = main_menu.instance()
#   add_child(reset_game)
#   load_main_menu()
  
