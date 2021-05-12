extends Node2D

var units = []
var selectedUnit = ''

# TODO: move this to camera
var minZoom = 1
var maxZoom = 4
var zoomStep = 0.5
var _moveCamera = false;
var _previousPosition: Vector2 = Vector2(0, 0);

var cursorMode = ''  # build, select, move, ''
var draggedObject = ''

# TODO: move this to external json file
var buildingData = {
	"mine": {
		"imagePath": "res://tiles/mine.png",
		"size": [3,3]
	},
	"road": {
		"imagePath": "res://tiles/roads/AD.png",
		"size": [1,1]
	}
}


func addUnit(tilePos, name):
	var unit = load('res://Tank.tscn').instance()
	add_child(unit)
	unit.setPosition(tilePos)
	units.push_back(unit)	

func placeRoad(tilePos):
	#get rid of the 
	#remove_child(draggedObject[0])
	#draggedObject = ''
	#cursorMode = ''
	$Tiles.updateRoad(tilePos, 'place')
	
func placeBuilding():
	# check if building can be built
#	var bW = buildingData[name]['size'][0]
#	var bH = buildingData[name]['size'][1]
#	for i in range(-(bW-1)/2,(bW-1)/2+1):
#		for j in range(-(bW-1)/2,(bW-1)/2+1):
#			if $Tiles.posToName(tilePos + Vector2(i,j)) != 'Ground':
#				print('cannot build')
#				return
	cursorMode = ''
	draggedObject = ''
				
	
	

func createBuilding(name):
	var building = Sprite.new()
	building.texture = load(buildingData[name]['imagePath'])
	add_child(building)
	return building

func removeBuilding(tilePos):
	pass

func addRoad(tilePos):
	pass
	
func removeRoad(tilePos):
	pass

func posToUnit(tilePos):
	print('Searching in position: ' + str(tilePos))
	for unit in units:
		if unit.worldToMap(unit.position) == tilePos:
			return unit
	return ''

func leftClick(tilePos):
	print(tilePos)
	#selectedUnit = posToUnit(tilePos)
	#if selectedUnit:
	#	print('Selected new unit')
	#print($Tiles.get_cellv(tilePos))
	
	if cursorMode == 'build':
		# roads are tiles and must be treated differently
		if draggedObject[1] == 'road':
			placeRoad(tilePos)
		else:
			placeBuilding()
		
		#if buildObject == 'road':
		#	$Tiles.updateRoad(tilePos, 'place')
		#else:
		#	addBuilding(tilePos, buildObject)

func rightClick(tilePos):
	if draggedObject:
		remove_child(draggedObject[0])
		draggedObject = ''
		cursorMode = ''
		
#	if cursorMode == 'build':
#		if draggedObject == 'road':
#			$Tiles.updateRoad(tilePos, 'remove')
#		else:
#			createBuilding(draggedObject)
#
#	$Tiles.updateRoad(tilePos, 'remove')
#	if selectedUnit:
#		print('Moving unit')
#		selectedUnit.setPathAndMove($Tiles.shortestPath(
#			selectedUnit.worldToMap(selectedUnit.position), tilePos))

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var absPos = (event.position-$Camera2D.get_viewport().size/2)*$Camera2D.zoom + $Camera2D.position
			var tilePos = $Tiles.world_to_map(absPos)
			match event.button_index:
				BUTTON_WHEEL_UP:
					if $Camera2D.zoom.x > minZoom:
						$Camera2D.zoom -= Vector2(zoomStep,zoomStep)
				BUTTON_WHEEL_DOWN:
					if $Camera2D.zoom.x < maxZoom:
						$Camera2D.zoom += Vector2(zoomStep,zoomStep)
				BUTTON_MIDDLE:
					_previousPosition = event.position;
					_moveCamera = true;
				BUTTON_LEFT:
					leftClick(tilePos)
				BUTTON_RIGHT:
					rightClick(tilePos)
					
		else:
			match event.button_index:
				BUTTON_MIDDLE:
					_moveCamera = false;
	if _moveCamera:
		$Camera2D.position.x += (_previousPosition.x - event.position.x)*$Camera2D.zoom.x;
		$Camera2D.position.y += (_previousPosition.y - event.position.y)*$Camera2D.zoom.y;
		_previousPosition = event.position;

func _ready():
	pass
	#draggedObject = addBuilding($Tiles.world_to_map(get_global_mouse_position()), 'mine')
	#addUnit(Vector2(0,3), name)
	#addUnit(Vector2(1,1), name)
	#addBuilding(Vector2(1,1), 'mine')
	#addBuilding(Vector2(1,5), 'mine2')

func _process(delta):
	if draggedObject:
		draggedObject[0].position = $Tiles.map_to_world(
			$Tiles.world_to_map(get_local_mouse_position())) + Vector2(0,64)

func _on_GUI_BuildMenuSelection(selectedOption):
	cursorMode = 'build'
	draggedObject = [createBuilding(selectedOption), selectedOption]
