extends Node

# Item table attributes
var item_id = null
var item_name
var item_type
var item_rarity
var item_options = {}
#

#ItemType table attributes
var item_class
var race
var min_damage
var max_damage
var armour
var inventory_width = 0
var inventory_height = 0
#

# Inventory table attributes
var inventory_x = 3
var inventory_y = 2
var owner_player
#

var is_valid = true

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
	
func get_race():
	return race
	
func set_race(race):
	self.race = race
	
func get_min_damage():
	return min_damage
	
func set_min_damage(min_damage):
	self.min_damage = min_damage
	
func get_max_damage():
	return max_damage
	
func set_max_damage(max_damage):
	self.max_damage = max_damage
	
func get_armour():
	return armour
	
func set_armour(armour):
	self.armour = armour
	
func get_inventory_width():
	return inventory_width
	
func set_inventory_width(inventory_width):
	self.inventory_width = inventory_width
	
func get_inventory_height():
	return inventory_height
	
func set_inventory_height(inventory_height):
	self.inventory_height = inventory_height
	
func get_inventory_x():
	return inventory_x
	
func set_inventory_x(inventory_x):
	self.inventory_x = inventory_x
	
func get_inventory_y():
	return inventory_y
	
func set_inventory_y(inventory_y):
	self.inventory_y = inventory_y
	
func get_slot_count():
	return inventory_width * inventory_height
	
func get_owner():
	return owner_player
	
func set_owner(player):
	owner_player = player
	
func build_item(item_id):
	var db_item = DatabaseManager.get_item(item_id)
	
	if db_item.size() <= 0:
		is_valid = false
		return self
		
	db_item = db_item[0]
	
	init_from_database(db_item)
	
	return self
	
func serialize():
	return {
		item_id = get_id(),
		item_name = get_name(),
		item_type = get_type(),
		item_rarity = get_rarity(),
		item_options = get_options(),
		item_class = get_class(),
		race = get_race(),
		min_damage = get_min_damage(),
		max_damage = get_max_damage(),
		armour = get_armour(),
		inventory_width = get_inventory_width(),
		inventory_height = get_inventory_height(),
		inventory_x = get_inventory_x(),
		inventory_y = get_inventory_y(),
		owner_player = get_owner()
	}
	
func deserialize(item):
	set_id(item.item_id)
	set_name(item.item_name)
	set_type(item.item_type)
	set_rarity(item.item_rarity)
	set_options(item.item_options)
	set_class(item.item_class)
	set_race(item.race)
	set_min_damage(item.min_damage)
	set_max_damage(item.max_damage)
	set_armour(item.armour)
	set_inventory_width(item.inventory_width)
	set_inventory_height(item.inventory_height)
	set_inventory_x(item.inventory_x)
	set_inventory_y(item.inventory_y)
	set_owner(item.owner_player)
	
	return self
	
func init_from_database(db_item):
	var db_item_type = DatabaseManager.get_item_type(db_item.item_type_fk)
	
	if db_item_type.size() <= 0:
		is_valid = false
		return
		
	db_item_type = db_item_type[0]
	
	# Item table attributes
	set_id(db_item.item_id)
	set_name(db_item.name)
	set_type(db_item.item_type_fk)
	set_rarity(db_item.item_rarity_fk)
	set_options(db_item.item_options)
	
	# Item type table attributes
	set_class(db_item_type.item_class_fk)
	set_race(db_item_type.race_fk)
	set_min_damage(db_item_type.min_damage)
	set_max_damage(db_item_type.max_damage)
	set_armour(db_item_type.armour)
	set_inventory_width(db_item_type.inventory_width)
	set_inventory_height(db_item_type.inventory_height)
	
func to_database_array():
	return [
		item_name,
		item_type,
		item_rarity,
		JSON.print(item_options)
	]