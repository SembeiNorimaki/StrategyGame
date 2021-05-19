extends Node2D

onready var tilemap = get_node('../Tiles');
onready var camera = get_node('../Camera2D');
onready var highlightedTile = get_node('../HighlightedTile');

var healthBar


var prevTile = Vector2(0,0)
var currentTile = Vector2(0,0)
var isSelected = false
var path = []
var vel = Vector2(0, 0)
var unitInfo = {
	'Owner': 'Player',
	'HP': 12,
	'Attack': 5,
	'AP': 20
}

func getInfo():
	return unitInfo
	
func setInfo(key, val):
	unitInfo[key] = val

func getHit(damage):
	unitInfo['HP'] -= damage
	if unitInfo['HP'] <= 0:
		print('Unit destroyed')
		

func setPosition(tilePos):
	position = tilemap.mapToWorldCentered(tilePos)
	currentTile = tilePos
	prevTile = tilePos

func setPathAndMove(path_):
	path = path_
	vel = calculateNewVel()
	$AnimatedSprite.play()
	
func calculateNewVel():
	if tilemap.mapToWorldCentered(path[0])[0] > position [0] and \
			tilemap.mapToWorldCentered(path[0])[1] > position [1]:
		vel = Vector2(1,0.5)
		$AnimatedSprite.animation = 'SE'
		$AnimatedSprite.flip_h = false
	if tilemap.mapToWorldCentered(path[0])[0] < position [0] and \
			tilemap.mapToWorldCentered(path[0])[1] > position [1]:
		vel = Vector2(-1,0.5)
		$AnimatedSprite.animation = 'SE'
		$AnimatedSprite.flip_h = true
	if tilemap.mapToWorldCentered(path[0])[0] > position [0] and \
			tilemap.mapToWorldCentered(path[0])[1] < position [1]:
		vel = Vector2(1,-0.5)
		$AnimatedSprite.animation = 'NE'
		$AnimatedSprite.flip_h = false
	if tilemap.mapToWorldCentered(path[0])[0] < position [0] and \
			tilemap.mapToWorldCentered(path[0])[1] < position [1]:
		vel = Vector2(-1,-0.5)
		$AnimatedSprite.animation = 'NE'
		$AnimatedSprite.flip_h = true
	return vel
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	healthBar = TextureProgress.new()
	healthBar.texture_progress = load('res://bar_green.png')
	healthBar.value = 100
	if unitInfo['Owner'] == 'Player':
		healthBar.visible = isSelected
	else:
		healthBar.visible = true
	healthBar.rect_position = position + Vector2(-100,-120)
	healthBar.rect_size = Vector2(50,40)
	add_child(healthBar)

	
	#position = Vector2(0,64)
	#path = tilemap.shortestPath(worldToMap(position), Vector2(4,4))
	#vel = calculateNewVel()
	#print(path)
	#$AnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#camera.position = position
	if unitInfo['Owner'] == 'Player':
		healthBar.visible = isSelected
	else:
		healthBar.visible = true
		
	healthBar.value = unitInfo['HP']
		
	if len(path):
		if isSelected:
			highlightedTile.points = [
				(position + Vector2(0,-64)),
				(position + Vector2(128,0)),
				(position + Vector2(0,64)),
				(position + Vector2(-128,0)),
				(position + Vector2(0,-64))]
				
		if position.distance_to(tilemap.mapToWorldCentered(path[0])) <= 1:
			print('Arrived to point: ' + str(path[0]))
			unitInfo.AP -= 1
			path.pop_front()
			if len(path) == 0:
				vel = Vector2(0,0)
				$AnimatedSprite.stop()
			else:
				vel = calculateNewVel()
		else:
			position += vel

