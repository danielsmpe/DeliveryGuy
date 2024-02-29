extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite_2d = $Human_Sprite
@onready var item_sprite = $Item_Sprite
@onready var game_end = $Camera2D/GameEnd

@onready var item_drop = load("res://Scene/item.tscn")
@onready var npc_1 = $"../NPC1"
@onready var npc_2 = $"../NPC2"
@onready var npc_3 = $"../NPC3"
@onready var npc_4 = $"../NPC4"
@onready var pickup_sound = $pickup_sound
@onready var deliver_sound = $deliver_sound
@onready var completestage = $"../../Sound/completestage"


# Get t$Sprite2Dhe gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#item
var carrying_item: bool = false
var deliver: bool = false
var items_in_range: Array = []
var recipient: Array = []
var total_packages: int = 4  # Set this to the total number of packages in your game
var delivered_packages: int = 0

#score
var score: int = 0

func _ready():
	item_sprite.hide()

func _physics_process(delta):
	
	if abs(velocity.x) > 1 :
		sprite_2d.animation = "Running"
	else:
		sprite_2d.animation = "Idle"

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "Jumping"
		
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func _input(event):
	if event.is_action_pressed("Pickup"):
		if carrying_item:
			drop_item()
		else:
			if !items_in_range.is_empty():
				pickup_item(items_in_range.pick_random())
	
func pickup_item(item: Area2D):
	item.queue_free()
	carrying_item = true
	item_sprite.show()

	# Play pickup sound
	pickup_sound.play()
	
func drop_item():
	item_sprite.hide()
	var item = item_drop.instantiate()
	if recipient.is_empty():
		item.position = position
		get_parent().add_child(item)
		carrying_item = false
	else :
		for npc_area in recipient:
			var npc = npc_area.get_parent()  # Assuming the NPC is the direct parent of the area
			if npc != null:
				npc.hide()

		delivered_packages += 1
		# Check if all packages are delivered
		if delivered_packages == total_packages:
			all_packages_delivered()

		# Play deliver sound
		deliver_sound.play()
		# Save high score
		score += 1
		$Camera2D/Score_Point.text = str(score)
		Scoresaved.update_high_score(score)
			
		recipient.clear()
		item.queue_free()
		carrying_item = false

func all_packages_delivered():
	# Implement the logic for when all packages are delivered
	print("All packages delivered! Game over or proceed to the next level.")
	var panel_paused = $Camera2D/Panel
	var bg_sound = $"../../Sound/bg_sound"
	panel_paused.show()
	game_end.show()
	completestage.play()
	bg_sound.stop()
	Engine.time_scale = 0


func _on_pickup_range_area_entered(area):
	if area.is_in_group("item_drop"):
		items_in_range.append(area)
		print("enter pickup range")
func _on_pickup_range_area_exited(area):
	if area.is_in_group("item_drop"):
		items_in_range.erase(area)
		print("exit pickup range")
func _on_delivery_range_area_entered(area):
	if area.is_in_group("recipient"):
		recipient.append(area)
		print("enter deliver area")
func _on_delivery_range_area_exited(area):
	if area.is_in_group("recipient"):
		recipient.erase(area)
		print("exit deliver area")
		
