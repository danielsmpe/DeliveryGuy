extends Node

@onready var pause_menu = $Character/MainCharacter/Camera2D/PauseMenu
@onready var panel_paused = $Character/MainCharacter/Camera2D/Panel
@onready var gameover = $Character/MainCharacter/Camera2D/Gameover

@onready var gameoversound = $Sound/gameoversound
@onready var bg_sound = $Sound/bg_sound



var paused = false
var panelpaused = false
var timer_game: Timer
var time_label  # Reference to your game over menu scene

func _ready():
	time_label = $Character/MainCharacter/Camera2D/Time_label # Gantilah dengan nama label sesuai kebutuhan
	timer_game = $TimerGame

	# Connect timeout signal
	timer_game.timeout.connect(self._on_timer_game_timeout)

	# Start the timer
	timer_game.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	# Format waktu ke menit dan detik (hh:mm)
	var seconds = int(timer_game.time_left) % 60

	# Format waktu menjadi dua digit pertama
	var formatted_time = "%02d" % seconds

	# Set nilai label
	time_label.text = "Time : " + formatted_time + " S"

func pauseMenu():
	if paused:
		pause_menu.hide()
		panel_paused.hide()
		Engine.time_scale = 1
	else:
		print("pause")
		pause_menu.show()
		panel_paused.show()
		Engine.time_scale = 0
	
	paused = !paused

func _on_timer_game_timeout():
	 # Stop the timer (optional)
	timer_game.stop()
	# Show the game over menu
	show_game_over_menu()
	
func show_game_over_menu():
	# You can customize this based on your game over menu scene
	panel_paused.show()
	gameover.show()
	gameoversound.play()
	bg_sound.stop()
	Engine.time_scale = 0
	
	

