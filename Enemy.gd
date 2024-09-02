extends MarginContainer





var CurrentHealth = 10
var Health = 10

#called when node enters tree scene for the first time.
func _ready():
	$VBoxContainer/ImageContainer/Image.scale *= $VBoxContainer/ImageContainer.rect_min_size/$VBoxContainer/ImageContainer/Image.texture.get_size()
	$VBoxContainer/Bar/TextureProgress.value = 100
	$VBoxContainer/Bar/Count/Background/Number.text = str(CurrentHealth)
