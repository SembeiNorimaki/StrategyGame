extends Node2D

var cityData
var units = []
var buildings = []
var enemies = []

# TODO: move this to external json file
var buildingData = {
	"mine": {
		"imagePath": "res://tiles/mine.png",
		"size": [3,3],
		"HP": 1000,
	},
	"wall": {
		"imagePath": "res://tiles/wall/wall1.png",
		"size": [1,1]
	},
	"wall2": {
		"imagePath": "res://tiles/wall/wall2.png",
		"size": [1,1]
	},
	"refinery": {
		"imagePath": "res://buildings/refinery.png",
		"size": [3,3]
	},
	"road": {
		"imagePath": "res://tiles/roads/AD.png",
		"size": [1,1]
	}
}



func loadCity(filename):
	var file = File.new()
	file.open(filename, file.READ)
	cityData = JSON.parse(file.get_as_text()).result
	file.close()

	# populate tileset
	$Tiles.populateTiles(cityData['map'])
	
	for building in cityData['buildings']:
		addBuilding(Vector2(building['Position'][0], building['Position'][1]), 
					building['Type'])
					
	for unit in cityData['units']:
		addUnit(Vector2(unit['Position'][0], unit['Position'][1]), unit['Type'])

func createBuilding(tilePos, name):
	#var building = Sprite.new()
	var building = load('res://Building.tscn').instance()
	building.texture = load(buildingData[name]['imagePath'])
	add_child(building)	
	building.position = $Tiles.mapToWorldCentered(tilePos)
	building.setInfo({
		'Owner': 'Player',
		'HP': 100,
		'Size': buildingData[name]['size']
	})
	buildings.append(building)
	return building

func addEnemy(tilePos, name):
	var enemy = load('res://units/EnemyTank.tscn').instance()
	add_child(enemy)
	enemy.setInfo('Owner', 'Enemy')
	enemy.setPosition(tilePos)
	enemies.append(enemy)


func addUnit(tilePos, name):
	var unit = load('res://units/Tank.tscn').instance()
	add_child(unit)
	unit.setPosition(tilePos)
	units.append(unit)

func addBuilding(tilePos, name):
	var building = createBuilding(tilePos, name)
	




func _ready():
	loadCity('res://cities/city1.json')
	addEnemy(Vector2(0,5), '')
	#$Line2D.set_point_position(0, Vector2(0,0))


#func _process(delta):
#	pass
