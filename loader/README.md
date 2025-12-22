<div align="center">

SOUJA HUB

A Modern, Feature-Rich, and Highly Customizable Script Loader for Roblox.

</div>

<p align="center">
<img src="https://img.shields.io/badge/Version-2.8-blue.svg" alt="Version 2.8">
<img src="https://img.shields.io/badge/License-Open_Source-brightgreen.svg" alt="License: Open Source">
<img src="https://img.shields.io/badge/Status-Active-success.svg" alt="Status: Active">
</p>

<!--
IMPORTANT: For the best result, replace the URL below with a screenshot or GIF of your loader!
A good visual is the most important part of a README.
-->

<p align="center">
<img 
  src=""<img width="842" height="523" alt="image" src="https://github.com/user-attachments/assets/105e8d5a-4564-4957-b6a5-b92ffdb1e808" />"
  alt="Souja Hub Showcase" width="700"/>
</p>


Souja Hub is designed to provide a seamless and visually appealing experience for loading scripts. It intelligently adapts to the game you're in, offers deep customization through a simple configuration, and ensures stability with robust, modern features.

✨ Key Features

🚀 Intelligent Script Loading: Automatically detects the current game and loads the correct script, with a universal fallback.

🎨 Remote Theming Engine: Customize the entire UI's color scheme from a remote themes.json file without needing to update the script.

🔔 Live Update Notifier: Checks for new versions and displays a clean "Update Available!" message to keep users informed.

MAINTENANCE Remote Status Control: A remote "kill-switch" allows you to disable the loader for maintenance and display a custom message.

📰 In-Loader Changelog: A "What's New?" button displays the latest updates directly within the UI.

🎵 Dynamic Audio Visualizer: The UI border pulses in sync with in-game sounds for an immersive visual effect.

🔧 Extremely Customizable: A centralized Config table makes it trivial to change everything from the name and logo to animation speeds and script URLs.

🐞 Robust Error Handling: If a script fails to load, it provides a clear error and a one-click "Copy Error" button for easy support.

🚀 How to Use

Getting started is as simple as possible.

Copy the Script: Get the full source code.

Open Your Executor: Launch Roblox and attach your preferred script executor.

Execute: Paste the script and run it.

The loader will handle the rest, automatically detecting the game and loading the appropriate script.

⚙️ How It Works: The Loader Lifecycle

The script follows a precise sequence to ensure a smooth and secure execution:

Environment Check: Cleans up any old instances of the loader to prevent UI conflicts.

Theme & Asset Loading: Fetches themes and other remote assets from the URLs defined in the configuration.

Pre-Checks:

Status Check: Verifies the status.json file to ensure the hub is online.

Whitelist Check: If enabled, validates the user's UserId against the Whitelist.txt file.

UI Construction: Dynamically builds and animates the entire user interface into view.

Loading Sequence: Simulates a loading process while running background tasks like the version check and UI animations.

Script Injection: Identifies the game's PlaceId, downloads the corresponding script from the Config, and executes it using loadstring().

Transition: On success, it plays a success animation and fades out. On failure, it enters an error state with debugging tools.

🔧 Configuration Deep Dive

The Config table is your central control panel. Below is a detailed guide to all available options.

Main Settings & Identity
Setting	Type	Default Value	Description
HubName	string	"SOUJA HUB"	The main title displayed in the loader.
Subtitle	string	"Public Version"	The smaller text displayed below the title.
LogoLetter	string	"S"	The letter used in the logo if no ImageLogo is provided.
ImageLogo	string	""	A Roblox asset ID (rbxassetid://...) for a custom image logo.
Version	string	"2.8"	The current version of your loader, used for the update check.
ActiveTheme	string	"Discord"	The name of the theme to use from your themes.json file.
Feature Toggles
Setting	Type	Default Value	Description
StatusCheckEnabled	boolean	true	If true, checks the remote status.json file before loading.
WhitelistEnabled	boolean	false	If true, validates the user against the Whitelist.txt file.
VersionCheckEnabled	boolean	true	If true, checks for and notifies the user of new updates.
ChangelogEnabled	boolean	true	If true, the "What's New?" button will be visible.
AudioVisEnabled	boolean	true	If true, the UI border will react to in-game audio.
🌐 Guide to Hosting Remote Files

To have full control, you need to host your own configuration files. Use GitHub Gist or a repository and use the "Raw" file URL.

<details>
<summary><strong>📄 themes.json - For UI Colors</strong></summary>


This JSON file contains your UI themes. The key is the theme name (which you use in ActiveTheme), and the value is an object of colors.

code
JSON
download
content_copy
expand_less
{
  "Discord": {
    "Primary": [88, 101, 242],
    "Background": [54, 57, 63],
    "Text": [255, 255, 255],
    "Failure": [237, 66, 69]
  },
  "Solarized Dark": {
    "Primary": [38, 139, 210],
    "Background": [0, 43, 54],
    "Text": [238, 232, 213],
    "Failure": [220, 50, 47]
  }
}
</details>

<details>
<summary><strong>📄 status.json - For Remote On/Off Switch</strong></summary>


This JSON file acts as a remote "kill switch." If allow_load is false, the loader will stop and display the message.

code
JSON
download
content_copy
expand_less
{
  "allow_load": false,
  "message": "The hub is currently under maintenance. Please check back later!"
}
</details>

<details>
<summary><strong>📄 Version.txt, Changelog.txt, & Whitelist.txt</strong></summary>


These are simple plain text files.

Version.txt: Contains only the latest version number (e.g., 2.9).

Changelog.txt: Contains your update notes. The content is displayed as-is.

Whitelist.txt: Contains one Roblox UserId per line for access control.

</details>

License & Credits

License: This project is open source and free to use. You are permitted to modify, reuse, and redistribute this script for any purpose.

Credits: Authored by the SouljaWitchSrc community. All credit for the original creation and design goes to them.
