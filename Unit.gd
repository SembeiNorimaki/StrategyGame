extends Node2D

onready var tilemap = get_node('../Tiles');
onready var camera = get_node('../Camera2D');

var path = []
var vel = Vector2(0, 0)

func worldToMap(coord):
	return tilemap.world_to_map(coord)

func mapToWorld(coord):
	return (tilemap.map_to_world(coord) + Vector2(0,64))

func setPosition(pos):
	position = mapToWorld(pos)

func setPathAndMove(path_):
	path = path_
	vel = calculateNewVel()
	$AnimatedSprite.play()
	
func calculateNewVel():
	if mapToWorld(path[0])[0] > position [0] and mapToWorld(path[0])[1] > position [1]:
		vel = Vector2(1,0.5)
		$AnimatedSprite.animation = 'SE'
		$AnimatedSprite.flip_h = false
	if mapToWorld(path[0])[0] < position [0] and mapToWorld(path[0])[1] > position [1]:
		vel = Vector2(-1,0.5)
		$AnimatedSprite.animation = 'SE'
		$AnimatedSprite.flip_h = true
	if mapToWorld(path[0])[0] > position [0] and mapToWorld(path[0])[1] < position [1]:
		vel = Vector2(1,-0.5)
		$AnimatedSprite.animation = 'NE'
		$AnimatedSprite.flip_h = false
	if mapToWorld(path[0])[0] < position [0] and mapToWorld(path[0])[1] < position [1]:
		vel = Vector2(-1,-0.5)
		$AnimatedSprite.animation = 'NE'
		$AnimatedSprite.flip_h = true
	return vel
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#position = Vector2(0,64)
	#path = tilemap.shortestPath(worldToMap(position), Vector2(4,4))
	#vel = calculateNewVel()
	#print(path)
	#$AnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#camera.position = position
	if len(path):
		if position.distance_to(mapToWorld(path[0])) <= 1:
			print('Arrived to point: ' + str(path[0]))
			path.pop_front()
			if len(path) == 0:
				vel = Vector2(0,0)
				$AnimatedSprite.stop()
			else:
				vel = calculateNewVel()
		else:
			position += vel

