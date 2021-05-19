extends Line2D

var angle
var targetPos

signal HitUnit(coord, damage)

func setPositions(ori, dst):
	targetPos = dst
	angle = dst.angle_to_point(ori)
	points = [ori, ori + Vector2(30,0).rotated(angle)]
	visible = true
	print('Ori:' + str(ori))
	print('Target:' + str(dst))
	


func _ready():
	pass
#	var ori = Vector2(300,300)
#	var dst = Vector2(400,320)
#	setPositions(ori, dst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:		
		#print(targetPos.distance_to(points[0]))
		if targetPos.distance_to(points[0]) > 5:
			points[0] += Vector2(3,0).rotated(angle)
			points[1] = points[0] - Vector2(30,0).rotated(angle)			
		else:
			visible = false
			emit_signal("HitUnit", targetPos, 5)
			print('Booom')
