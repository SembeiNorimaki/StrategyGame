extends Sprite

var buildingInfo = {
	'Owner': 'Player',
	'HP': 100,
	'Size': [3,3]
}

func getInfo():
	return buildingInfo

func setInfo(infoDict):
	buildingInfo = infoDict
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
