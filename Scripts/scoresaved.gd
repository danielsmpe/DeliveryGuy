extends Node

var score: int = 0
var high_score: int = 0

func load_high_score():
	# Load the high score from the file
	var file_path = "user://high_score.txt"  # Adjust the file path accordingly
	if ResourceLoader.exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var high_score_str = file.get_as_text()
		file.close()

		# Convert the string to an integer
		high_score = high_score_str.to_int()

func save_high_score():
	# Save the high score to the file
	var file_path = "user://high_score.txt"  # Adjust the file path accordingly
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(str(high_score))
	file.close()
	
	print("High score saved to: ", file_path)
	
func update_high_score(new_score):
	if new_score > high_score:
		high_score = new_score
		save_high_score()


