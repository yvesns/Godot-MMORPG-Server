extends Node

var items = []

func _ready():
	pass

func init(character_name):
	var database_inventory = DatabaseManager.get_inventory(character_name)
	var item
	
	for inventory_item in database_inventory:
		item = DatabaseManager.get_item(inventory_item.item_fk)
		
		if item.size() > 0:
			item = item[0]
			item.inventory_x = inventory_item.inventory_x
			item.inventory_y = inventory_item.inventory_y
			items.append(item)
	
	return true
	
func get_items():
	return items