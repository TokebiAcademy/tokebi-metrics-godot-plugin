# install_tokebi.gd - Fresh installer that generates working code
@tool
extends EditorScript

func _run():
	print("🚀 Installing Tokebi Analytics SDK...")
	
	# Create directories
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("addons"):
		dir.make_dir("addons")
	if not dir.dir_exists("addons/tokebi"):
		dir.make_dir("addons/tokebi")
	
	# Create plugin files
	_create_plugin_cfg()
	_create_plugin_gd()
	_create_setup_dialog()
	
	# Refresh filesystem
	EditorInterface.get_resource_filesystem().scan()
	
	print("✅ Tokebi Plugin installed!")
	print("📋 Next: Project Settings > Plugins > Enable 'Tokebi Analytics SDK'")

func _create_plugin_cfg():
	var content = "[plugin]\n"
	content += "name=\"Tokebi Analytics SDK\"\n"
	content += "description=\"Analytics SDK for Godot\"\n"
	content += "author=\"Tokebi\"\n"
	content += "version=\"1.0\"\n"
	content += "script=\"plugin.gd\"\n"
	_write_file("res://addons/tokebi/plugin.cfg", content)

func _create_plugin_gd():
	var content = "@tool\n"
	content += "extends EditorPlugin\n\n"
	content += "const SetupDialog = preload(\"res://addons/tokebi/setup_dialog.gd\")\n"
	content += "var dock\n\n"
	content += "func _enter_tree():\n"
	content += "\tdock = SetupDialog.new()\n"
	content += "\tadd_control_to_dock(DOCK_SLOT_LEFT_UL, dock)\n\n"
	content += "func _exit_tree():\n"
	content += "\tremove_control_from_docks(dock)\n"
	_write_file("res://addons/tokebi/plugin.gd", content)

func _create_setup_dialog():
	var content = "@tool\n"
	content += "extends Control\n\n"
	content += "var api_key_input: LineEdit\n\n"
	content += "func _ready():\n"
	content += "\t_create_ui()\n\n"
	content += "func _create_ui():\n"
	content += "\tvar vbox = VBoxContainer.new()\n"
	content += "\tadd_child(vbox)\n"
	content += "\tvar title = Label.new()\n"
	content += "\ttitle.text = \"Tokebi SDK Setup\"\n"
	content += "\tvbox.add_child(title)\n"
	content += "\tvbox.add_child(HSeparator.new())\n"
	content += "\tvar game_info = Label.new()\n"
	content += "\tgame_info.text = \"Game: \" + ProjectSettings.get_setting(\"application/config/name\", \"Unnamed Godot Game\")\n"
	content += "\tgame_info.add_theme_color_override(\"font_color\", Color(0.7, 0.7, 0.7))\n"
	content += "\tvbox.add_child(game_info)\n"
	content += "\tvbox.add_child(HSeparator.new())\n"
	content += "\tvar api_label = Label.new()\n"
	content += "\tapi_label.text = \"API Key:\"\n"
	content += "\tvbox.add_child(api_label)\n"
	content += "\tapi_key_input = LineEdit.new()\n"
	content += "\tapi_key_input.placeholder_text = \"Enter your API key\"\n"
	content += "\tapi_key_input.secret = true\n"
	content += "\tvbox.add_child(api_key_input)\n"
	content += "\tvar install_btn = Button.new()\n"
	content += "\tinstall_btn.text = \"Install SDK\"\n"
	content += "\tinstall_btn.pressed.connect(_on_install_pressed)\n"
	content += "\tvbox.add_child(install_btn)\n\n"
	content += "func _on_install_pressed():\n"
	content += "\tvar api_key = api_key_input.text.strip_edges()\n"
	content += "\tif api_key.is_empty():\n"
	content += "\t\tprint(\"[Tokebi] ERROR: API Key is required\")\n"
	content += "\t\treturn\n"
	content += "\t_install_sdk(api_key)\n\n"
	content += "func _install_sdk(api_key: String):\n"
	content += "\tvar sdk_content = \"# Tokebi Analytics SDK\\n\"\n"
	content += "\tsdk_content += \"extends Node\\n\\n\"\n"
	content += "\tsdk_content += \"const API_KEY = \\\"\" + api_key + \"\\\"\\n\"\n"
	content += "\tsdk_content += \"const ENDPOINT = \\\"https://tokebi-api.vercel.app\\\"\\n\\n\"\n"
	content += "\tsdk_content += \"var game_name: String = \\\"\\\"\\n\"\n"
	content += "\tsdk_content += \"var game_id: String = \\\"\\\"\\n\"\n"
	content += "\tsdk_content += \"var player_id: String = \\\"\\\"\\n\\n\"\n"
	content += "\tsdk_content += \"func _ready():\\n\"\n"
	content += "\tsdk_content += \"\\tprint(\\\"[Tokebi] Initializing SDK...\\\")\\n\"\n"
	content += "\tsdk_content += \"\\tgame_name = ProjectSettings.get_setting(\\\"application/config/name\\\", \\\"Unnamed Godot Game\\\")\\n\"\n"
	content += "\tsdk_content += \"\\tprint(\\\"[Tokebi] Game Name: \\\", game_name)\\n\"\n"
	content += "\tsdk_content += \"\\tplayer_id = _get_or_create_player_id()\\n\"\n"
	content += "\tsdk_content += \"\\tprint(\\\"[Tokebi] Player ID: \\\", player_id)\\n\"\n"
	content += "\tsdk_content += \"\\t_detect_multiplayer_mode()\\n\"\n"
	content += "\tsdk_content += \"\\t_register_game()\\n\\n\"\n"
	content += "\tsdk_content += \"func _detect_multiplayer_mode():\\n\"\n"
	content += "\tsdk_content += \"\\tvar multiplayer_api = get_tree().get_multiplayer()\\n\"\n"
	content += "\tsdk_content += \"\\tif not multiplayer_api.has_multiplayer_peer():\\n\"\n"
	content += "\tsdk_content += \"\\t\\tprint(\\\"[Tokebi] Mode: Single Player\\\")\\n\"\n"
	content += "\tsdk_content += \"\\t\\treturn\\n\"\n"
	content += "\tsdk_content += \"\\tif multiplayer_api.is_server() or multiplayer_api.get_unique_id() == 1:\\n\"\n"
	content += "\tsdk_content += \"\\t\\tprint(\\\"[Tokebi] Mode: Host/Server - Will track\\\")\\n\"\n"
	content += "\tsdk_content += \"\\t\\treturn\\n\"\n"
	content += "\tsdk_content += \"\\telse:\\n\"\n"
	content += "\tsdk_content += \"\\t\\tprint(\\\"[Tokebi] Mode: Client - Will NOT track\\\")\\n\"\n"
	content += "\tsdk_content += \"\\t\\tgame_id = \\\"client_no_track\\\"\\n\\n\"\n"
	content += "\tsdk_content += \"func _get_or_create_player_id() -> String:\\n\"\n"
	content += "\tsdk_content += \"\\tvar file_path = \\\"user://tokebi_player_id\\\"\\n\"\n"
	content += "\tsdk_content += \"\\tif FileAccess.file_exists(file_path):\\n\"\n"
	content += "\tsdk_content += \"\\t\\tvar file = FileAccess.open(file_path, FileAccess.READ)\\n\"\n"
	content += "\tsdk_content += \"\\t\\tif file:\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\tvar id = file.get_line()\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\tfile.close()\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\treturn id\\n\"\n"
	content += "\tsdk_content += \"\\tvar new_id = \\\"player_\\\" + str(Time.get_unix_time_from_system()) + \\\"_\\\" + str(randi() % 10000)\\n\"\n"
	content += "\tsdk_content += \"\\tvar file = FileAccess.open(file_path, FileAccess.WRITE)\\n\"\n"
	content += "\tsdk_content += \"\\tif file:\\n\"\n"
	content += "\tsdk_content += \"\\t\\tfile.store_line(new_id)\\n\"\n"
	content += "\tsdk_content += \"\\t\\tfile.close()\\n\"\n"
	content += "\tsdk_content += \"\\treturn new_id\\n\\n\"\n"
	content += "\tsdk_content += \"func _register_game():\\n\"\n"
	content += "\tsdk_content += \"\\tvar http = HTTPRequest.new()\\n\"\n"
	content += "\tsdk_content += \"\\tadd_child(http)\\n\"\n"
	content += "\tsdk_content += \"\\thttp.request_completed.connect(_on_register_response)\\n\"\n"
	content += "\tsdk_content += \"\\tvar headers = [\\\"Authorization: \\\" + API_KEY, \\\"Content-Type: application/json\\\"]\\n\"\n"
	content += "\tsdk_content += \"\\tvar body = {\\\"gameName\\\": game_name, \\\"platform\\\": \\\"godot\\\"}\\n\"\n"
	content += "\tsdk_content += \"\\thttp.request(ENDPOINT + \\\"/api/games\\\", headers, HTTPClient.METHOD_POST, JSON.stringify(body))\\n\\n\"\n"
	content += "\tsdk_content += \"func _on_register_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):\\n\"\n"
	content += "\tsdk_content += \"\\tif response_code == 200 or response_code == 201:\\n\"\n"
	content += "\tsdk_content += \"\\t\\tvar json = JSON.new()\\n\"\n"
	content += "\tsdk_content += \"\\t\\tif json.parse(body.get_string_from_utf8()) == OK and json.data.has(\\\"game_id\\\"):\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\tgame_id = str(json.data.game_id)\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\tprint(\\\"[Tokebi] Game registered! ID: \\\", game_id)\\n\"\n"
	content += "\tsdk_content += \"\\t\\telse:\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\tprint(\\\"[Tokebi] No game_id in response\\\")\\n\"\n"
	content += "\tsdk_content += \"\\telse:\\n\"\n"
	content += "\tsdk_content += \"\\t\\tprint(\\\"[Tokebi] Registration failed with code: \\\", response_code)\\n\\n\"\n"
	content += "\tsdk_content += \"func track(event_type: String, payload: Dictionary = {}, force_track: bool = false):\\n\"\n"
	content += "\tsdk_content += \"\\tif game_id == \\\"client_no_track\\\" and not force_track:\\n\"\n"
	content += "\tsdk_content += \"\\t\\tprint(\\\"[Tokebi] Skipping (client): \\\", event_type)\\n\"\n"
	content += "\tsdk_content += \"\\t\\treturn\\n\"\n"
	content += "\tsdk_content += \"\\tif game_id.is_empty() or player_id.is_empty():\\n\"\n"
	content += "\tsdk_content += \"\\t\\treturn\\n\"\n"
	content += "\tsdk_content += \"\\tvar final_payload = payload.duplicate()\\n\"\n"
	content += "\tsdk_content += \"\\tif final_payload.is_empty():\\n\"\n"
	content += "\tsdk_content += \"\\t\\tfinal_payload[\\\"timestamp\\\"] = Time.get_unix_time_from_system()\\n\"\n"
	content += "\tsdk_content += \"\\tvar http = HTTPRequest.new()\\n\"\n"
	content += "\tsdk_content += \"\\tadd_child(http)\\n\"\n"
	content += "\tsdk_content += \"\\thttp.request_completed.connect(func(r,c,h,b): http.queue_free())\\n\"\n"
	content += "\tsdk_content += \"\\tvar headers = [\\\"Authorization: \\\" + API_KEY, \\\"Content-Type: application/json\\\"]\\n\"\n"
	content += "\tsdk_content += \"\\tvar event_body = {\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\\"eventType\\\": event_type,\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\\"payload\\\": final_payload,\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\\"gameId\\\": game_id,\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\\"playerId\\\": player_id,\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\\"platform\\\": \\\"godot\\\",\\n\"\n"
	content += "\tsdk_content += \"\\t\\t\\\"environment\\\": \\\"development\\\" if OS.is_debug_build() else \\\"production\\\"\\n\"\n"
	content += "\tsdk_content += \"\\t}\\n\"\n"
	content += "\tsdk_content += \"\\tprint(\\\"[Tokebi] Tracking: \\\", event_type, \\\" PlayerId: \\\", player_id)\\n\"\n"
	content += "\tsdk_content += \"\\thttp.request(ENDPOINT + \\\"/api/track\\\", headers, HTTPClient.METHOD_POST, JSON.stringify(event_body))\\n\\n\"\n"
	content += "\tsdk_content += \"func track_level_start(level: String):\\n\"\n"
	content += "\tsdk_content += \"\\ttrack(\\\"level_start\\\", {\\\"level\\\": level})\\n\\n\"\n"
	content += "\tsdk_content += \"func track_level_complete(level: String, time_taken: float):\\n\"\n"
	content += "\tsdk_content += \"\\ttrack(\\\"level_complete\\\", {\\\"level\\\": level, \\\"time\\\": time_taken})\\n\\n\"\n"
	content += "\tsdk_content += \"func track_client_event(event_type: String, payload: Dictionary = {}):\\n\"\n"
	content += "\tsdk_content += \"\\ttrack(event_type, payload, true)\\n\"\n"
	content += "\tvar file = FileAccess.open(\"res://tokebi.gd\", FileAccess.WRITE)\n"
	content += "\tif file:\n"
	content += "\t\tfile.store_string(sdk_content)\n"
	content += "\t\tfile.close()\n"
	content += "\t\tprint(\"[Tokebi] SDK installed! Add to AutoLoad: Tokebi -> res://tokebi.gd\")\n"
	content += "\telse:\n"
	content += "\t\tprint(\"[Tokebi] Failed to write SDK file\")\n"
	_write_file("res://addons/tokebi/setup_dialog.gd", content)

func _write_file(path: String, content: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()
		print("📁 Created: ", path)
	else:
		print("❌ Failed to create: ", path)
