#!/bin/sh

export ULTRASCHALL_RELEASE=Ultraschall-3.1
export ULTRASCHALL_RELEASE_DISK_READ_WRITE=$ULTRASCHALL_RELEASE-rw.so
export ULTRASCHALL_RELEASE_DISK_READ_ONLY=$ULTRASCHALL_RELEASE.so
export ULTRASCHALL_RELEASE_INTERMEDIATE=$ULTRASCHALL_RELEASE-im

# Cleanup old installer image
if [ -f ./$ULTRASCHALL_RELEASE_DISK_READ_ONLY ]; then
	rm -f ./$ULTRASCHALL_RELEASE_DISK_READ_ONLY
fi

# Cleanup temporary intermediate directory
if [ -d ./intermediate ]; then
	rm -rf ./intermediate
fi
mkdir ./intermediate

# Cleanup temporary build directory
if [ -d ./build ]; then
	rm -rf ./build
fi
mkdir ./build

# Cleanup temporary payload directory
if [ -d ./Payload ]; then
	rm -rf ./Payload
fi
mkdir ./Payload
mkdir ./Payload/Add-ons

# Copy uninstall script to payload directory
#cp ../REAPER/Scripts/Uninstall.command ./Payload/Uninstall.command

# Copy removal script to payload directory
#cp ../REAPER/Scripts/Remove\ legacy\ audio\ devices.command ./Payload/Remove\ legacy\ audio\ devices.command

# Copy resources to payload 'Add-ons' directory
cp ../REAPER/Documentation/Keymap.pdf ./Payload/Add-ons/Ultraschall\ Keyboard\ Layout.pdf
cp ../REAPER/Documentation/Keymap.pptx ./Payload/Add-ons/Ultraschall\ Keyboard\ Layout.pptx
cp ../REAPER/Resources/Ultraschall\ App-Icon.png ./Payload/Add-ons/Ultraschall\ App-Icon.png
cp ../REAPER/Resources/Ultraschall\ Webbanner.pdf ./Payload/Add-ons/Ultraschall\ Webbanner.pdf
cp ../REAPER/Resources/Ultraschall\ Webbanner\ 400px.png ./Payload/Add-ons/Ultraschall\ Webbanner\ 400px.png
cp ../REAPER/Resources/Ultraschall\ Webbanner\ 800px.png ./Payload/Add-ons/Ultraschall\ Webbanner\ 800px.png
cp ../REAPER/Resources/Ultraschall\ Webbanner\ 2000px.jpg ./Payload/Add-ons/Ultraschall\ Webbanner\ 2000px.jpg

# Copy REAPER theme to payload directory
cp ../REAPER/Themes/Ultraschall_3.1_MAC.ReaperConfigZip ./Payload/Ultraschall_3.1.ReaperConfigZip

# Copy background image to payload directory
mkdir ./Payload/.background
cp ./Resources/backgroundv3.png ./Payload/.background/background.png

# Create Ultraschall REAPER Extension package
xcodebuild -project ../REAPER/Plugin/reaper_ultraschall/reaper_ultraschall.xcodeproj -configuration Release
pkgbuild --root ../REAPER/Plugin/reaper_ultraschall/Build/Release --scripts ./Scripts/Plugin --identifier fm.ultraschall.Plugin.Extension --install-location /Library/Application\ Support/REAPER/UserPlugins ./Build/UltraschallPluginExtension.pkg

# Create Ultraschall Soundboard package
pushd ../Soundboard
./Build/build_mac_plugin.sh
popd

# Create Ultraschall Soundboard package
pkgbuild --root ../Soundboard/Files/AudioUnit --identifier fm.ultraschall.Soundboard.Component --install-location /Library/Audio/Plug-Ins/Components ./Build/UltraschallSoundboard.pkg

# Create Ultraschall Soundboard extras package
pkgbuild --root ../Soundboard/Extras --identifier fm.ultraschall.Soundboard.Extras --install-location /Library/Application\ Support/Ultraschall ./Build/UltraschallSoundboardExtras.pkg

# Create ITSR StudioLink package
pkgbuild --root ./3rdParty/StudioLink/Macintosh --identifier com.itsr.StudioLink.Components --install-location /Library/Audio/Plug-Ins/Components ./Build/StudioLink.pkg

# Create SWS REAPER Plugin Extension package
chmod 755 ./3rdParty/SWS/Macintosh/UserPlugins/Scripts/preinstall
pkgbuild --root ./3rdParty/SWS/Macintosh/UserPlugins/Payload --scripts ./3rdParty/SWS/Macintosh/UserPlugins/Scripts --identifier com.mj-s.sws --install-location /Library/Application\ Support/REAPER/UserPlugins ./Build/SWS_Extension-2.9.6.pkg

# Create SWS REAPER Plugin Scripts package
chmod 755 ./3rdParty/SWS/Macintosh/Scripts/Scripts/preinstall
pkgbuild --root ./3rdParty/SWS/Macintosh/Scripts/Payload --scripts ./3rdParty/SWS/Macintosh/Scripts/Scripts --identifier com.mj-s.sws.Scripts --install-location /Library/Application\ Support/REAPER/Scripts ./Build/SWS_ExtensionScripts-2.9.6.pkg

# Create Ultraschall Resources package
pkgbuild --root ../REAPER/Plugin/Resources --identifier fm.ultraschall.Resources --install-location /Library/Application\ Support/Ultraschall ./Build/UltraschallResources.pkg

# Create Ultraschall Soundflower Uninstaller package
pkgbuild --scripts ../REAPER/Tools/SoundflowerUninstaller/Scripts --nopayload --identifier fm.ultraschall.SoundflowerUninstaller ./Build/UltraschallSoundflowerUninstaller.pkg

# Copy Ultraschall Hub package
cp ./3rdParty/Hub/UltraschallHub-2015-11-12.pkg ./Payload/UltraschallHub.pkg

# Create preliminary unsigned installer package
productbuild --distribution ./Scripts/distribution.xml --resources ./Resources --package-path ./Build ./Payload/Ultraschall-unsigned.pkg
# rm -rf ./Build

# Create final signed installer package
productsign --sign "Developer ID Installer: Heiko Panjas (8J2G689FCZ)" ./Payload/Ultraschall-unsigned.pkg ./Payload/$ULTRASCHALL_RELEASE.pkg
rm -f ./Payload/Ultraschall-unsigned.pkg

# Create installer disk image
hdiutil create -format UDRW -srcfolder ./Payload -fs HFS+ -volname $ULTRASCHALL_RELEASE ./$ULTRASCHALL_RELEASE_DISK_READ_WRITE

# Mount installer disk image
mkdir -p ./$ULTRASCHALL_RELEASE_INTERMEDIATE
hdiutil attach -mountpoint ./$ULTRASCHALL_RELEASE_INTERMEDIATE ./$ULTRASCHALL_RELEASE_DISK_READ_WRITE

# Create signature on uninstall script
codesign --sign "Developer ID Application: Heiko Panjas (8J2G689FCZ)" ./$ULTRASCHALL_RELEASE_INTERMEDIATE/Uninstall.command

# Create signature on removal script
codesign --sign "Developer ID Application: Heiko Panjas (8J2G689FCZ)" ./$ULTRASCHALL_RELEASE_INTERMEDIATE/Remove\ legacy\ audio\ devices.command

echo Creating disk layout...
echo '
   tell application "Finder"
     tell disk "Ultraschall-3.1.intermediate"
           open
           set current view of container window to icon view
           set toolbar visible of container window to false
           set statusbar visible of container window to false
           set the bounds of container window to {100, 100, 800, 540}
           set viewOptions to the icon view options of container window
           set arrangement of viewOptions to not arranged
           set background picture of viewOptions to file ".background:background.png"
           set position of item "Ultraschall-3.1.pkg" of container window to {50, 30}
           set position of item "Ultraschall_3.1.ReaperConfigZip" of container window to {200, 30}
           set position of item "README.html" of container window to {50, 135}
           set position of item "INSTALL.html" of container window to {200, 135}
           set position of item "CHANGELOG.html" of container window to {350, 135}
           set position of item "UltraschallHub.pkg" of container window to {50, 220}
           set position of item "Add-ons" of container window to {200, 220}
           set position of item "Uninstall.command" of container window to {50, 320}
           set position of item "Remove legacy audio devices.command" of container window to {200, 320}
           close
           open
           update without registering applications
           delay 2
     end tell
   end tell
' | osascript
echo done.

sync

# Unmount installer disk image
hdiutil detach ./$ULTRASCHALL_RELEASE_INTERMEDIATE

# Convert installer disk image
hdiutil convert -format UDRO -o ./$ULTRASCHALL_RELEASE_DISK_READ_ONLY ./$ULTRASCHALL_RELEASE_DISK_READ_WRITE

# Clean-up
rm -rf ./$ULTRASCHALL_RELEASE_INTERMEDIATE
rm -rf ./$ULTRASCHALL_RELEASE_DISK_READ_WRITE
rm -rf ./Payload
rm -rf ./Intermediate
rm -rf ./Build
