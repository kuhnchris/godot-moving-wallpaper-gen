extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var foff = preload("res://TextureRectThatFucksOff.tscn")
var globalSize
var textureCache = {}


func genIconsNew() ->void:
	var x: float = 0
	var y: float = 0
	var dir = Directory.new()
	dir.open("res://images")
	if dir.list_dir_begin(true,true) != OK:
		print("Cannot open firectory. :(")
		return
	var file = dir.get_next()
	print("initial file: ",file)
	while file != "":
		#print("file: ",file)
		if not file.ends_with(".import"):
			file = dir.get_next()
			continue
		file = file.replace(".import","")
		
		if file in textureCache:
			pass
		else:
			textureCache[file] = ResourceLoader.load("res://images/"+file)
		
		file = dir.get_next()
		
	var m:Image = Image.new()
	var sqr = sqrt(textureCache.size())
	x = 34.0 * sqr 
	y = sqr
	var limit = 16384
	while x > limit:
		print("x is still too big: ",x)
		x = x / 2.0
		y += 4
	m.create(int(round(x)), 34*int(round(y)), false, Image.FORMAT_RGBA8)
	m.fill(Color.transparent)
	var a: int = 0
	var b: int = 0
	var mm:Image = Image.new()
	mm.create(int(round(x)), 34,false,Image.FORMAT_RGBA8)
	mm.fill(Color.transparent)
	for n in textureCache.keys():
		if textureCache[n].get_data().get_format() != Image.FORMAT_RGBA8:
			print("error: incompatible rgb(a): ",n)
			continue
		if textureCache[n].get_size().x != 16:
			print("invalid size: ",n)
			continue
		mm.blit_rect(textureCache[n].get_data(),Rect2(0,0,20,20),Vector2(34*a,0))
		a = a + 1
		if (34*a > x):
			m.blit_rect(mm,Rect2(0,0,x,34),Vector2(0,34*b))
			mm.fill(Color.transparent)
			a = 0
			b += 1
	b = b - 1
	m.crop(x,34*b)
	m.save_png("/tmp/test.png")
	var t = ImageTexture.new()
	t.create_from_image(m)

	for i in range(10):
		for j in range(10):
			var spr = foff.instance()
			spr.texture = t
			spr.expand = false
			spr.rect_size = Vector2(x,34*b)
			spr.rect_position = Vector2(x*j+(12*j),34*b*i)
			spr.modulate.a = .5
			spr.move = Vector2(1.0,1.0)
			add_child(spr)

			"""
			spr = foff.instance()
			spr.texture = t
			spr.expand = false
			spr.rect_size = Vector2(x,34*i)
			spr.rect_position = Vector2(x*i,34*j)
			spr.modulate.a = .5
			spr.move = Vector2(1,1)
			add_child(spr)

			spr = foff.instance()
			spr.texture = t
			spr.expand = false
			spr.rect_size = Vector2(x,34*i)
			spr.rect_position = Vector2(x*i,34*j*b)
			spr.modulate.a = .5
			spr.move = Vector2(1,1)
			add_child(spr)
			"""
			#if ( 34 * x  ) > ( globalSize.x * 2 ):
			#	x = -1
			#	y = y + 1
			#x = x + 1
			

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
			if not file.ends_with(".import"):
				file = dir.get_next()
				continue
			file = file.replace(".import","")
			
			var spr = foff.instance()
			if file in textureCache:
				pass
			else:
				textureCache[file] = ResourceLoader.load("res://images/"+file)

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
	#genIcons(5)
	genIconsNew()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
