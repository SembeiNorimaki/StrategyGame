extends Node2D

var mapData
var W = 100-1.86
var H = 86.6-1.86


func populateMap(mapData):
	var tmp
	for i in mapData:
		if i['Owner'] == 'Player':
			tmp = load('res://maps/MapBlue.tscn').instance()
		elif i['Owner'] == 'Neutral':
			tmp = load('res://maps/MapWhite.tscn').instance()
		elif i['Owner'] == 'Enemy':
			tmp = load('res://maps/MapRed.tscn').instance()
			
		if not int(i['Position'][0]) % 2:
			tmp.rect_position = Vector2(
				i['Position'][0]*3*W/4,
				i['Position'][1]*H)
		else:
			tmp.rect_position = Vector2(
				i['Position'][0]*3*W/4,
				i['Position'][1]*H+H/2)
		add_child(tmp)
		
	


func loadMap(filename):
	var file = File.new()
	file.open(filename, file.READ)
	mapData = JSON.parse(file.get_as_text()).result
	file.close()

	# populate tileset
	populateMap(mapData['tiles'])


# Called when the node enters the scene tree for the first time.
func _ready():
	loadMap('res://cities/map.json')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
