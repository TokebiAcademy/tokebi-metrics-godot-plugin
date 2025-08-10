# Tokebi Metrics Godot Plugin

An analytics plugin for Godot games to connect with Tokebi Metrics backend.

## Features
- Event tracking
- Funnel analysis
- User segmentation

## Requirements
- Godot version 4.0 or higher
- Tokebi Metrics account [https://tokebimetrics.com]

## Installation
# Tokebi Godot Plugin — Quick Setup Steps

1. **Download Installer**  
   Get the installer script from:  
   https://tokebimetrics.com/documentation-guide/godot-plugin-guide or use this repo

2. **Add Installer to Project**  
   Copy the file `install_tokebi.gd` into the root folder of your Godot project (where your `project.godot` lives).

3. **Run Installer**  
   Open `install_tokebi.gd` in Godot’s script editor and run it. This will set up the plugin files and configuration automatically.

4. **Enable Plugin**  
   In Godot editor, go to **Project Settings → Plugins**.  
   Find **Tokebi Analytics SDK** and enable it.

5. **Configure API Key**  
   In the new **Tokebi Setup** dock, enter your API key (from your Tokebi dashboard).

6. **Set AutoLoad**  
   Go to **Project Settings → AutoLoad**, add the generated `tokebi.gd` script as an autoload singleton named `Tokebi`.

7. **Start Tracking Events**  
   In your game scripts, track analytics events with:

   ```gdscript
   Tokebi.track("event_name", {"key": "value"})


## License
MIT License. See LICENSE file.

## Documentation
More detailed docs at — [https://tokebimetrics.com/documentation-guide/godot-plugin-guide]

## Contact
Created by Marco Diaz — [https://tokebimetrics.com]
