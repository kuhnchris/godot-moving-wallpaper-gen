extends TextureRect
class_name TextureRectThatFucksOff

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var move: Vector2 = Vector2(.5,.5)
var idx: float

# Called when the node enters the scene tree for the first time.
func _ready():
	#idx = rand_range(0,10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	idx = idx + .1
	self.rect_position.x = self.rect_position.x - move.x
	self.rect_position.y = self.rect_position.y - move.y
	pass
