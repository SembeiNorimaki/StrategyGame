extends TileMap

var W = 256
var H = 128

var tileName2Id = {
	'Ground':0,
	'Water':1,
	'AB':2,   
	'ABC':3,   
	'ABCD':4,
	'ABD':5,   
	'AC':6,   
	'ACD':7,   
	'AD':8,   
	'BC':9,
	'BCD':10,
	'BD':11,
	'CD':12	
}

var tileId2Name = {
	0: 'Ground',
	1: 'Water',
	2: 'AB',   
	3: 'ABC',   
	4: 'ABCD',
	5: 'ABD',   
	6: 'AC',   
	7: 'ACD',   
	8: 'AD',   
	9: 'BC',
	10: 'BCD',
	11: 'BD',
	12: 'CD'
}


func mapToWorldCentered(coord):
	return map_to_world(coord) + Vector2(0,64)

func MessageListener():
	print('message received')


func shortestPath(ori, dest):
	var path = []
	while (ori[0] != dest[0]):
		if ori[0] < dest[0]:
			ori[0] += 1	
		else:
			ori[0] -= 1	
		path.push_back(Vector2(ori[0], ori[1]))
	while (ori[1] != dest[1]):
		if ori[1] < dest[1]:
			ori[1] += 1	
		else:
			ori[1] -= 1	
		path.push_back(Vector2(ori[0], ori[1]))
	return path


func populateTiles(tileData):
	for j in range(tileData.size()):
		for i in range(tileData[0].size()):
			set_cellv(Vector2(i,j), tileData[j][i])
	for j in range(tileData.size()):
		for i in range(tileData[0].size()):
			updateRoad(Vector2(i,j), 'update')


func getRoadTileId(tilePos):
	var neighbors = 0
	if not get_cell(tilePos[0]-1,tilePos[1]) in [-1,0,1]: neighbors +=1
	if not get_cell(tilePos[0],tilePos[1]-1) in [-1,0,1]: neighbors +=2
	if not get_cell(tilePos[0],tilePos[1]+1) in [-1,0,1]: neighbors +=4
	if not get_cell(tilePos[0]+1,tilePos[1]) in [-1,0,1]: neighbors +=8
	
	match neighbors:
		0:
			return tileName2Id['AD']
		1:
			return tileName2Id['AD']
		2:
			return tileName2Id['BC']
		3:
			return tileName2Id['AB']
		4:
			return tileName2Id['BC']
		5:
			return tileName2Id['AC']
		6:
			return tileName2Id['BC']
		7:
			return tileName2Id['ABC']
		8:
			return tileName2Id['AD']
		9:
			return tileName2Id['AD']
		10:
			return tileName2Id['BD']
		11:
			return tileName2Id['ABD']
		12:
			return tileName2Id['CD']
		13:
			return tileName2Id['ACD']
		14:
			return tileName2Id['BCD']
		15:
			return tileName2Id['ABCD']


func isRoad(tilePos):
	if get_cellv(tilePos) >= 2:
		return true
	return false


func posToName(tilePos):
	var id = get_cellv(tilePos)
	if id == -1:
		return ''
	elif id == 0:
		return 'Ground'
	elif id == 1:
		return 'Water'
	elif id == 2:
		return 'Road'
	
	

func updateRoad(tilePos, action):
	if action == 'remove' and isRoad(tilePos):
		set_cellv(tilePos, tileName2Id['Ground'])
		updateRoad(tilePos+Vector2(1,0), 'update')
		updateRoad(tilePos+Vector2(-1,0), 'update')
		updateRoad(tilePos+Vector2(0,1), 'update')
		updateRoad(tilePos+Vector2(0,-1), 'update')
		return 'Ground'
	elif action == 'place' and not isRoad(tilePos):
		set_cellv(tilePos, getRoadTileId(tilePos))
		updateRoad(tilePos+Vector2(1,0), 'update')
		updateRoad(tilePos+Vector2(-1,0), 'update')
		updateRoad(tilePos+Vector2(0,1), 'update')
		updateRoad(tilePos+Vector2(0,-1), 'update')
		return tileId2Name[getRoadTileId(tilePos)]
	elif action == 'update' and isRoad(tilePos):
		set_cellv(tilePos, getRoadTileId(tilePos))
		return tileId2Name[getRoadTileId(tilePos)]


func _ready():
	pass


#func _process(delta):
#	pass
