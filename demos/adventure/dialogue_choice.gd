extends Label

export(Color) var default_color
export(Color) var highlight_color

func select():
	set("custom_colors/font_color", highlight_color)
	
func deselect():
	set("custom_colors/font_color", default_color)
