extends CharacterBody2D

# Variable untuk menyimpan item yang diterima
var received_item

func _on_item_dropped(item):
	# Pastikan NPC (recipient) tidak memiliki item sebelumnya
	if is_visible():
		# Lakukan sesuatu dengan item yang dijatuhkan (misalnya, simpan referensi ke item tersebut)
		print("Item received by NPC:", item)
		received_item = item
		hide()
		get_parent().current_npc = self  # Set current_npc pada karakter
	else:
		print("NPC already has an item. Cannot receive another.")
