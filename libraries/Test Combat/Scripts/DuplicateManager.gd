# --- ORIGINAL CODE (Turned into comments) ---
# extends CharacterBody3D

# --- NEW CODE ---
extends Node

var resource_counters = {}

func get_duplicate_resource(original_res: Resource) -> Resource:
	if original_res == null: return null
	
	# --- ORIGINAL CODE (Turned into comments) ---
	# var new_res = original_res.duplicate(true)
	
	# --- NEW UPDATED LOGIC ---
	# Use deep duplication (true) to ensure internal Arrays in Dialog are also unique
	var new_res = original_res.duplicate(true)
	
	var base_name = "NPC_Resource"
	
	if "name" in new_res:
		var res_name = new_res.get("name")
		if res_name != null and res_name != "":
			base_name = res_name
	elif original_res is HomelessDialogData:
		base_name = "Dialog"
	
	if base_name == "Player":
		return new_res
	
	if not resource_counters.has(base_name):
		resource_counters[base_name] = 0
	resource_counters[base_name] += 1
	
	var unique_id = base_name + "_" + str(resource_counters[base_name])
	
	if "name" in new_res:
		new_res.set("name", unique_id)
			
	return new_res
