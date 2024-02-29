extends Control

@onready var main = $"../../../../"


func _on_resume_button_pressed():
	main.pauseMenu()


func _on_quit_button_pressed():
	main.pauseMenu()
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
