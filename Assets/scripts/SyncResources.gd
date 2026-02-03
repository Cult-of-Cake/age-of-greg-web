@tool
extends EditorScript

# THIS SCRIPT IS MEANT TO BE RUN IN THE GODOT EDITOR WITH EVERY SCRIPT UPDATE
# TO RUN, OPEN IN THE GODOT EDITOR AND PRESS CTRL + SHIFT + X

func _run() -> void:
	var script_folder := "res://Assets/scripts/"
	var script_folder_dir_access := DirAccess.open(script_folder)
	# deal with new text files that don't yet have resources associated with them.
	var unmatched_script_files: Array = Array(DirAccess.get_files_at(script_folder)).filter(\
		#make sure to only target files with one txt extension
		func (cur): return (cur.split(".").size() == 2) && (cur[1].contains("txt"))
	).filter(\
		func (cur): return !script_folder_dir_access.file_exists(cur + ".script.tres")
	).map(\
		func (cur): 
			var ret_resource := SceneManagerScript.new()
			ret_resource.script_source_file = script_folder + cur
			return ret_resource
	).reduce(
		func (acc,cur):
			var e := ResourceSaver.save(cur, cur.script_source_file + ".script.tres")
			if e != OK: 
				acc.push_back(cur.script_source_file)
			return acc
	,[])
	
	print("==== Failed Script creations ====")
	print(unmatched_script_files)
	var script_resources = Array(DirAccess.get_files_at(script_folder)).filter(\
		func (cur): return cur.contains(".script.tres")\
	)
	for rScript in script_resources:
		var resource_file = ResourceLoader.load(script_folder + rScript)
		resource_file.load_script()
		print(resource_file.script_content)
		ResourceSaver.save(resource_file,script_folder + rScript)
	
	
