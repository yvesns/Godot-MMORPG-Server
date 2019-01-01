extends Node

var items = []

func _ready():
	pass

func build_inventory(character_name):
	var database_inventory = DatabaseManager.get_inventory(character_name)
	var item
	
	for inventory_item in database_inventory:
		item = Global.Item.new().build_item(inventory_item.item_fk)
		item.set_inventory_x(inventory_item.inventory_x)
		item.set_inventory_y(inventory_item.inventory_y)
		item.set_owner(inventory_item.player_character_fk)
		
		if item.is_valid:
			items.append(item)
	
	return self
	
func get_items():
	return items
	
func serialize():
	var serialized = []
	
	for item in items:
		serialized.append(item.serialize())
		
	return serialized
	
func deserialize(serialized_items):
	items = []
	
	for item in serialized_items:
		items.append(Global.Item.new().deserialize(item))
		
	return self