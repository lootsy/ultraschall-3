#!/bin/sh

# Uninstall Ultraschall REAPER Extension
if [ -f ~/Library/Application\ Support/REAPER/UserPlugins/reaper_Ultraschall.dylib ]; then
	rm -f ~/Library/Application\ Support/REAPER/UserPlugins/reaper_Ultraschall.dylib
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_einspieler.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_einspieler.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_import_shownotes.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_import_shownotes.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_notes.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_notes.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_set_edit.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_set_edit.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_set_marker.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_set_marker.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_set_namedmarker.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_set_namedmarker.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_webserver.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/ultraschall_webserver.py
fi

# Uninstall SWS REAPER Extension
if [ -f ~/Library/Application\ Support/REAPER/UserPlugins/reaper_sws.dylib ]; then
	rm -f ~/Library/Application\ Support/REAPER/UserPlugins/reaper_sws.dylib
fi

if [ -f ~/Library/Application\ Support/REAPER/UserPlugins/whatsnew.txt ]; then
	rm -f ~/Library/Application\ Support/REAPER/UserPlugins/whatsnew.txt
fi

if [ -f ~/Library/Application\ Support/REAPER/UserPlugins/license.txt ]; then
	rm -f ~/Library/Application\ Support/REAPER/UserPlugins/license.txt
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/sws_python.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/sws_python.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/sws_python32.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/sws_python32.py
fi

if [ -f ~/Library/Application\ Support/REAPER/Scripts/sws_python64.py ]; then
	rm -f ~/Library/Application\ Support/REAPER/Scripts/sws_python64.py
fi

# Uninstall Ultraschall Soundboard
if [ -d ~/Library/Audio/Plug-Ins/VST/Soundboard.vst ]; then
	rm -rf ~/Library/Audio/Plug-Ins/VST/Soundboard.vst
fi

if [ -d ~/Documents/Ultraschall ]; then
	rm -rf ~/Documents/Ultraschall
fi

# Uninstall Ultraschall Driver
if [ -d /Library/Extensions/UltraschallHub.kext ]; then
	sudo kextunload /Library/Extensions/UltraschallHub.kext
	sudo kextunload /Library/Extensions/UltraschallHub.kext
	sudo rm -rf /Library/Extensions/UltraschallHub.kext
fi

sudo rm -f /var/db/receipts/com.mj-s.sws.*
sudo rm -f /var/db/receipts/fm.ultraschall.*


