extends Node2D
class_name Turrets

var type
var category: String
var mob_arr = []
var built = false
var mob
var is_ready: bool = true
var range_texture: Sprite2D
var cooldown: bool = false
var magazine_max: int
var magazine_current: int

func _ready():
	if built:
		magazine_max = GameData.tower_data[type]["magazine_count"]
		magazine_current = magazine_max
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]
		get_node("Gun/Marker2D/BarrelSmoke").set_emitting(false)





func _physics_process(_delta):
	if mob_arr.size() != 0 and built:
		select_mob()
		if not get_node("AnimationPlayer").is_playing():
			turn()
		if is_ready and cooldown == false:
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
	is_ready = false
	if category == "projectile":
		fire_gun()
		magazine_current -= 1
		print(magazine_current)
		print(cooldown)
		if magazine_current <= 0:
			reload_timer()
	elif category == "missle":
		fire_missle()
		magazine_current -= 1
	mob.on_hit(GameData.tower_data[type]["damage"])
	if(mob.hp <= 0):
		mob_arr.erase(mob)
	await (get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout)
	is_ready = true

func fire_gun():
	get_node("AnimationPlayer").play("fire")

func fire_missle():
	pass

func reload_timer():
	cooldown = true
	get_node("Gun/Marker2D/BarrelSmoke").set_emitting(true)
	await get_tree().create_timer(GameData.tower_data[type]["reload_timer"]).timeout
	cooldown = false
	magazine_current = magazine_max
	get_node("Gun/Marker2D/BarrelSmoke").set_emitting(false)


##TARGET ARR

func _on_range_body_exited(body:Node2D):
	mob_arr.erase(body.get_parent())

func _on_range_body_entered(body:Node2D):
	mob_arr.append(body.get_parent())


##MOUSE INTERACTION
