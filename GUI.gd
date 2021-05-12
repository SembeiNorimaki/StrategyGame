extends MarginContainer

onready var popup_menu = $HBoxContainer/MenuButton.get_popup()

signal BuildMenuSelection(menuText)


func _ready():
	popup_menu.connect("id_pressed", self, "item_pressed")

func item_pressed(id):
	emit_signal("BuildMenuSelection", popup_menu.get_item_text(id))


