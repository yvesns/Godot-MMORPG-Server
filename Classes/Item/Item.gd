extends Node

var item_id = null
var item_name
var item_class
var item_type
var item_rarity
var item_options = {}
var inventory_slot_width = 0
var inventory_slot_height = 0
var inventory_x = 3
var inventory_y = 2

func _ready():
	pass
	
func is_stackable():
	return false
	
func get_id():
	return item_id
	
func set_id(item_id):
	self.item_id = item_id
	
func get_name():
	return item_name
	
func set_name(item_name):
	self.item_name = item_name
	
func get_class():
	return item_class
	
func set_class(item_class):
	self.item_class = item_class
	
func get_type():
	return item_type
	
func set_type(item_type):
	self.item_type = item_type
	
func get_rarity():
	return item_rarity
	
func set_rarity(item_rarity):
	self.item_rarity = item_rarity
	
func get_options():
	return item_options

func set_options(item_options):
	self.item_options = item_options
	
func get_inventory_width():
	return inventory_slot_width
	
func set_inventory_width(inventory_slot_width):
	self.inventory_slot_width = inventory_slot_width
	
func get_inventory_height():
	return inventory_slot_height
	
func set_inventory_height(inventory_slot_height):
	self.inventory_slot_height = inventory_slot_height
	
func get_inventory_x():
	return inventory_x
	
func set_inventory_x(inventory_x):
	self.inventory_x = inventory_x
	
func get_inventory_y():
	return inventory_y
	
func get_width():
	return Global.inventory_slot_size * inventory_slot_width
	
func get_height():
	return Global.inventory_slot_size * inventory_slot_height
	
func get_slot_count():
	return inventory_slot_width * inventory_slot_height
	
func serialize():
	return {
		item_id = self.item_id,
		item_name = self.item_name,
		item_class = self.item_class,
		item_type = self.item_type,
		item_rarity = self.item_rarity,
		item_options = JSON.print(self.item_options, "", true),
		inventory_slot_width = self.inventory_slot_width,
		inventory_slot_height = self.inventory_slot_height,
		inventory_X = self.inventory_x,
		inventory_y = self.inventory_y
	}
	
func deserialize(item):
	set_id(item.item_id)
	set_name(item.item_name)
	set_class(item.item_class)
	set_type(item.item_type)
	set_rarity(item.item_rarity)
	set_options(item.item_options)
	set_inventory_width(item.inventory_slot_width)
	set_inventory_height(item.inventory_slot_height)
	
func init_from_database(db_item):
	set_id(db_item.item_id)
	set_name(db_item.name)
	set_type(db_item.item_type_fk)
	set_rarity(db_item.item_rarity_fk)
	set_options(db_item.item_options)
	
func to_database_array():
	return [
		item_name,
		item_type,
		item_rarity,
		JSON.print(item_options)
	]