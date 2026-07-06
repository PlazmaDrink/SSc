extends Node
var _cache : Dictionary = {}

# 1. Tell the manager to start loading an asset in the background
func request_load(path: String) -> void:
	if _cache.has(path):
		return # We already have it or are currently loading it
	# Start the background thread
	ResourceLoader.load_threaded_request(path)

	_cache[path] = "loading" # Placeholder so we know it's in progress

# 2. Try to get the asset (returns null if still loading)
func get_asset(path: String) -> Resource:
	# If it's fully loaded and cached, return it instantly
	if _cache.has(path) and typeof(_cache[path]) != TYPE_STRING:
		return _cache[path]
		
	# Check the status of the background thread
	var status = ResourceLoader.load_threaded_get_status(path)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var resource = ResourceLoader.load_threaded_get(path)
		_cache[path] = resource # Save it to the cache for next time
		return resource
		
	elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		# Still loading, handle this in your gameplay code
		return null 
		
	else:
		push_error("Failed to load: " + path)
		return null

# 3. CRITICAL: Free up memory when changing levels!
func clear_cache() -> void:
	_cache.clear()
