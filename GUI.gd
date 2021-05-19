extends MarginContainer

onready var popup_menu = $HBoxContainer/BuildButton.get_popup()

signal BuildMenuSelection(menuText)
signal MapViewPressed
signal EndTurnPressed

func _ready():
	popup_menu.connect("id_pressed", self, "item_pressed")

func item_pressed(id):
	emit_signal("BuildMenuSelection", popup_menu.get_item_text(id))


func _on_MapViewButton_pressed():
	emit_signal("MapViewPressed")


func _on_EndTurnButton_pressed():
	emit_signal("EndTurnPressed")
