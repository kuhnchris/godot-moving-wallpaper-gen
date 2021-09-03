extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var foff = preload("res://TextureRectThatFucksOff.tscn")
var globalSize
var textureCache = {}

func genIcons(repeats: int) ->void:
	var x: int = 0
	var y: int = 0
	var loop: int = 0

	while loop < repeats:
		var dir = Directory.new()
		dir.open("res://images")
		if dir.list_dir_begin(true,true) != OK:
			print("Cannot open firectory. :(")
			return
		var file = dir.get_next()
		print("initial file: ",file)
		while file != "":
			#print("file: ",file)
			if file.ends_with(".import"):
				file = dir.get_next()
				continue
			
			var spr = foff.instance()
			if file in textureCache:
				pass
			else:
				textureCache[file] = load("res://images/"+file)

			spr.texture = textureCache[file]
			spr.expand = true
			spr.rect_size = Vector2(20,20)
			spr.rect_position = Vector2(34 * x,34 * y)
			spr.modulate.a = .5
			add_child(spr)
			if ( 34 * x  ) > ( globalSize.x * 2 ):
				x = -1
				y = y + 1
			x = x + 1
			file = dir.get_next()
		loop = loop + 1

# Called when the node enters the scene tree for the first time.
func _ready():
	globalSize = get_tree().get_root().get_viewport().size
	genIcons(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
