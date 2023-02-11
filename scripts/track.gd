extends PathFollow

# Physics variable
export(float) var velocity = 0.005
export(float) var maxspeed = 0.13
export(float) var velocitydecay = 0.045
var v : float = 0

# Train related
export var wagons : int
export var offset_constant : float = 1.4
export var wagonModel : PackedScene
var wagonsInstances : Array
var offset_t = offset_constant


func _ready():
	for x in range(wagons):
		var temp_wagon = PathFollow.new()
		temp_wagon.set_offset(-offset_t)
		temp_wagon.set_rotation_mode(ROTATION_ORIENTED)
		# For some reasons this doesn't work:
		# > self.get_parent().add_child(temp_wagon)
		# So we use this:
		self.get_parent().call_deferred("add_child", temp_wagon)
		
		var t = wagonModel.instance()
		temp_wagon.add_child(t)
		
		wagonsInstances.append(temp_wagon)
		offset_t += offset_constant
	pass

func _process(delta) -> void:
	move(delta)
	
	# Move wagons with the locomotive
	for wagon in wagonsInstances:
		move_wagon(wagon)

func move(delta) -> void:
	if Input.is_action_pressed("train_forward"):
		v += velocity*delta
	else:
		v -=velocitydecay*delta
	v = clamp(v,0, maxspeed)
	self.set_offset(self.get_offset()+v)

func move_wagon(wagon) -> void:
	wagon.set_offset(wagon.get_offset()+v)
