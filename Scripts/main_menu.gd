class_name Main_menu
extends Control

@onready var Start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton
@onready var Exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton
@onready var Start_level = preload("res://Scene/game.tscn")

func _ready():
	Start_button.button_down.connect(on_start_pressed)
	Exit_button.button_down.connect(on_exit_pressed)
	Scoresaved.load_high_score()

	# Assuming you have a Label node named "LabelHighScore" on your main menu
	$MarginContainer/HBoxContainer/VBoxContainer/score.text = "High Score: " + str(Scoresaved.high_score)

func on_start_pressed() -> void :
	get_tree().change_scene_to_packed(Start_level)

func on_exit_pressed() -> void :
	get_tree().quit()
	


