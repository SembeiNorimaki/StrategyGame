extends Node2D

var units = []
var selectedUnit = ''
var selectedBuilding = ''

var playerTurn = true  # 0: enemy turn, 1: our turn

# TODO: move this to camera
var minZoom = 1
var maxZoom = 4
var zoomStep = 0.5
var _moveCamera = false;
var _previousPosition: Vector2 = Vector2(0, 0);

var cursorMode = ''  # build, select, move, '', attack
var draggedObject = ''

var crosshair = load("res://crosshair.png")


func enemyTurn():
	for enemy in $CityView.enemies:
		enemy.setPathAndMove([$CityView/Tiles.world_to_map(enemy.position) + Vector2(1,0)])
	
	
	# wait until all units have moved
	
	
	# then give turn back to the player
	playerTurn = true

func isCovered(wallCoord, worldCoord):
	#var point1 = wallCoord + Vector2(96,16)
	#var point2 = wallCoord + Vector2(-16,-24)
	
	var angle = rad2deg(worldCoord.angle_to_point(wallCoord))
	
	if angle < 0: 
		angle +=  360 
	print(angle)
	if angle < 112 or angle > 174:
		return false
	return true
	
func calculateHitPercentage(fromUnit, toCoord):
	var dist = fromUnit.position.distance_to(toCoord)
	var angle_ = rad2deg(toCoord.angle_to_point(fromUnit.position))
	if angle_ < 0: 
		angle_ +=  360 
	return int(100-dist/50)
#	$CityView/Line2D.points[0] = fromUnit.position
#	$CityView/Line2D.points[1] = toCoord
#	$CityView/Line2D.visible = true
#	print(toCoord)
#	print(fromUnit.position)	
#	return (dist)
	
func placeRoad(tilePos):
	#get rid of the 
	#remove_child(draggedObject[0])
	#draggedObject = ''
	#cursorMode = ''
	var tileName = $CityView/Tiles.updateRoad(tilePos, 'place')
	remove_child(draggedObject[0])
	draggedObject = [Sprite.new(), 'road']
	draggedObject[0].texture = load("res://tiles/roads/"+ tileName+".png")
	add_child(draggedObject[0])
	
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
				
func removeBuilding(tilePos):
	pass

func addRoad(tilePos):
	pass
	
func removeRoad(tilePos):
	pass

func posToUnit(tilePos):
	print('Searching in position: ' + str(tilePos))
	for unit in units:
		if unit.world_to_map(unit.position) == tilePos:
			return unit
	return ''

func isUnitHere(tilePos):
	for unit in $CityView.units:
		if tilePos == $CityView/Tiles.world_to_map(unit.position):
			return unit
	return ''

func isEnemyHere(tilePos):
	for enemy in $CityView.enemies:
		if tilePos == $CityView/Tiles.world_to_map(enemy.position):
			return enemy
	return ''


func isBuildingHere(tilePos):
	for building in $CityView.buildings:
		if tilePos == $CityView/Tiles.world_to_map(building.position):
			return building
	return ''

func leftClick(tilePos):	
	if cursorMode in ['', 'unit', 'building']:
		# if we already had a selected unit
		if cursorMode == 'unit':
			selectedUnit.isSelected = false
			
		selectedUnit = isUnitHere(tilePos)
		if selectedUnit:
			cursorMode = 'unit'
			selectedUnit.isSelected = true
			$CityView/HighlightedTile.points = [
				($CityView/Tiles.map_to_world(tilePos)),
				($CityView/Tiles.map_to_world(tilePos) + Vector2(128,64)),
				($CityView/Tiles.map_to_world(tilePos) + Vector2(0,128)),
				($CityView/Tiles.map_to_world(tilePos) + Vector2(-128,64)),
				($CityView/Tiles.map_to_world(tilePos))]
			$CityView/HighlightedTile.visible = true
			return
		
		selectedBuilding = isBuildingHere(tilePos)
		if selectedBuilding:
			cursorMode = 'building'
			#selectedBuilding.isSelected = true
			var buildingInfo = selectedBuilding.getInfo()
			print(buildingInfo)
			$CityView/HighlightedTile.points = [
				($CityView/Tiles.mapToWorldCentered(tilePos+Vector2(-(buildingInfo['Size'][0]-1)/2,-(buildingInfo['Size'][1]-1)/2)) + Vector2(0,-64)),
				($CityView/Tiles.mapToWorldCentered(tilePos+Vector2((buildingInfo['Size'][0]-1)/2,-(buildingInfo['Size'][1]-1)/2)) + Vector2(128,0)),
				($CityView/Tiles.mapToWorldCentered(tilePos+Vector2((buildingInfo['Size'][0]-1)/2,(buildingInfo['Size'][1]-1)/2)) + Vector2(0,64)),
				($CityView/Tiles.mapToWorldCentered(tilePos+Vector2(-(buildingInfo['Size'][0]-1)/2,(buildingInfo['Size'][1]-1)/2)) + Vector2(-128,0)),
				($CityView/Tiles.mapToWorldCentered(tilePos+Vector2(-(buildingInfo['Size'][0]-1)/2,-(buildingInfo['Size'][1]-1)/2)) + Vector2(0,-64))]
			$CityView/HighlightedTile.visible = true
			return
		
		
		cursorMode = ''
		$CityView/HighlightedTile.visible = false
			
	if cursorMode == 'attack':
		$CityView/Bullet.setPositions(selectedUnit.position, 
			$CityView/Tiles.mapToWorldCentered(tilePos))
		print(selectedUnit.position)
		print($CityView/Tiles.mapToWorldCentered(tilePos))
			
		print('Shot')
	
	
	if cursorMode == 'build':
		if draggedObject[1] == 'road':
			placeRoad(tilePos)
		else:
			cursorMode = ''
			draggedObject = ''
	
	
func rightClick(tilePos):
	if cursorMode == 'unit':
		var path_ = $CityView/Tiles.shortestPath(
			$CityView/Tiles.world_to_map(selectedUnit.position), tilePos)
		selectedUnit.setPathAndMove(path_)
		print(path_)
	
	if cursorMode == 'attack':
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		cursorMode = ''
		$CityView/Percentage.visible = false
	
	if draggedObject:
		print('aaaaa')
		$CityView.remove_child(draggedObject[0])
		draggedObject = ''
		cursorMode = ''
		
#	elif cursorMode == 'build':
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


func displayUnitInfo(unit):
	var txt = ''
	for i in unit.getInfo().keys():
		txt += i + ': ' + str(unit.getInfo()[i]) + '\n' 
	$CanvasLayer/GUI/HBoxContainer/RichTextLabel.text = txt
	

func _input(event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			var absPos = (event.position - 
				$CityView/Camera2D.get_viewport().size/2) * \
				$CityView/Camera2D.zoom + $CityView/Camera2D.position
			var tilePos = $CityView/Tiles.world_to_map(absPos)
			match event.button_index:
				BUTTON_WHEEL_UP:
					if $CityView/Camera2D.zoom.x > minZoom:
						$CityView/Camera2D.zoom -= Vector2(zoomStep,zoomStep)
				BUTTON_WHEEL_DOWN:
					if $CityView/Camera2D.zoom.x < maxZoom:
						$CityView/Camera2D.zoom += Vector2(zoomStep,zoomStep)
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
	
	elif event is InputEventKey and not event.echo:
		if Input.is_key_pressed(KEY_A) and selectedUnit:
			cursorMode = 'attack'
			#Input.set_custom_mouse_cursor(null, Input.CURSOR_CROSS)
			Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	elif event is InputEventMouseMotion:
		if cursorMode == 'attack' and selectedUnit:
			$CityView/Percentage.text = str(calculateHitPercentage(selectedUnit, get_local_mouse_position()))
			$CityView/Percentage.rect_scale = $CityView/Camera2D.zoom + Vector2(2,2)
			$CityView/Percentage.rect_position = get_global_mouse_position() + Vector2(10,10)
		
		#if cursorMode == 'attack':
#		$CityView/Line2D.set_point_position(0, $CityView/Tiles.mapToWorld(Vector2(3,8)))
#		$CityView/Line2D.set_point_position(1, get_global_mouse_position())
#
#		if isCovered($CityView/Tiles.mapToWorld(Vector2(3,9)), get_global_mouse_position()):
#			$CityView/Line2D.visible = false
#		else:
#			$CityView/Line2D.visible = true
	
	if _moveCamera:
		$CityView/Camera2D.position.x += (_previousPosition.x - 
			event.position.x)*$CityView/Camera2D.zoom.x;
		$CityView/Camera2D.position.y += (_previousPosition.y - 
			event.position.y)*$CityView/Camera2D.zoom.y;
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
		draggedObject[0].position = $CityView/Tiles.mapToWorldCentered(
			$CityView/Tiles.world_to_map(get_local_mouse_position())) + Vector2(0,64)
			
	if selectedUnit:
		displayUnitInfo(selectedUnit)

func _on_GUI_BuildMenuSelection(selectedOption):
	cursorMode = 'build'
	draggedObject = [$CityView.createBuilding(Vector2(0,0), selectedOption), 
					 selectedOption]


func _on_GUI_MapViewPressed():
	$CityView.visible = false
	$MapView.visible = true

func _on_GUI_EndTurnPressed():
	playerTurn = false
	enemyTurn()
	


func _on_Bullet_HitUnit(coord, damage):
	print('Bullet emmited signal')
	
	var enemy = isEnemyHere($CityView/Tiles.world_to_map(coord))
	if enemy:
		print('Enemy hit')
		enemy.getHit(damage)
