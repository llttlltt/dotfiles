#!/usr/bin/env zsh

###
#
#                Author : La Clémentine · https://medium.com/@laclementine/
#         Last Modified : 2023-09-11
#               Version : 1.04
#           Tested with : macOS Ventura 13.5.2
#
###

# From: https://medium.com/@laclementine/dotfile-for-mac-efe082ad0d6a
# See also: https://wilsonmar.github.io/dotfiles/

# Get current Username and User ID
CURRENT_USER=$(stat -f %Su /dev/console)
USER_ID=$(id -u "$CURRENT_USER")

############
# MENU BAR #
############

# Show battery percentage
sudo -u "$CURRENT_USER" defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# Show date and seconds
sudo -u "$CURRENT_USER" defaults write com.apple.menuextra.clock IsAnalog -int 0
sudo -u "$CURRENT_USER" defaults write com.apple.menuextra.clock Show24Hour -int 1
sudo -u "$CURRENT_USER" defaults write com.apple.menuextra.clock Date -int 0
sudo -u "$CURRENT_USER" defaults write com.apple.menuextra.clock ShowDayOfWeek -int 1
sudo -u "$CURRENT_USER" defaults write com.apple.menuextra.clock ShowSeconds -int 1

# Show bluetooth icon
sudo -u "$CURRENT_USER" defaults -currentHost write com.apple.controlcenter Bluetooth -int 18

# Show volume icon
sudo -u "$CURRENT_USER" defaults -currentHost write com.apple.controlcenter Sound -int 18

# Disable Siri
sudo -u "$CURRENT_USER" defaults write com.apple.Siri StatusMenuVisible -bool false
sudo -u "$CURRENT_USER" defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Add VPN icon
# sudo -u "$CURRENT_USER" open "/System/Library/CoreServices/Menu Extras/vpn.menu"

# Enable the input menu in the menu bar
# sudo -u "$CURRENT_USER" defaults write com.apple.TextInputMenu visible -bool true

# Add an additional input source to the list of input sources. Ex: French - Numerical
# sudo -u "$CURRENT_USER" defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>1111</integer><key>KeyboardLayout Name</key><string>French - numerical</string></dict>'

##########
# FINDER #
##########

# Show all filename extensions
sudo -u "$CURRENT_USER" defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar
sudo -u "$CURRENT_USER" defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
sudo -u "$CURRENT_USER" defaults write com.apple.finder ShowStatusBar -bool true

# New Finder windows points to home
sudo -u "$CURRENT_USER" defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Disable the warning when changing a file extension
sudo -u "$CURRENT_USER" defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Always show scrollbars. Possible values: `WhenScrolling`, `Automatic` and `Always`
sudo -u "$CURRENT_USER" defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Expand print panel by default
sudo -u "$CURRENT_USER" defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
sudo -u "$CURRENT_USER" defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Avoid creating .DS_Store files on network or USB volumes
sudo -u "$CURRENT_USER" defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
sudo -u "$CURRENT_USER" defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable recent apps in the Dock
launchctl asuser "$USER_ID" sudo -u "$CURRENT_USER" defaults write com.apple.dock show-recents -int 0

# Set custom wallpaper · Picture by https://basicappleguy.com
curl -o "/Users/Shared/wallpaper.png" "https://i.imgur.com/uonTUrp.png"
sudo -u "$CURRENT_USER" osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/Shared/wallpaper.png"'

# Display all files and folders sizes
# sudo -u "$CURRENT_USER" /usr/libexec/PlistBuddy -c "Set :'FK_StandardViewSettings':'ExtendedListViewSettingsV2':'calculateAllSizes' 'true'" /Users/$CURRENT_USER/Library/Preferences/com.apple.finder.plist
# sudo -u "$CURRENT_USER" /usr/libexec/PlistBuddy -c "Set :'FK_StandardViewSettings':'ListViewSettings':'calculateAllSizes' 'true'" /Users/$CURRENT_USER/Library/Preferences/com.apple.finder.plist
# sudo -u "$CURRENT_USER" /usr/libexec/PlistBuddy -c "Set :'StandardViewSettings':'ExtendedListViewSettingsV2':'calculateAllSizes' 'true'" /Users/$CURRENT_USER/Library/Preferences/com.apple.finder.plist
# sudo -u "$CURRENT_USER" /usr/libexec/PlistBuddy -c "Set :'StandardViewSettings':'ListViewSettings':'calculateAllSizes' 'true'" /Users/$CURRENT_USER/Library/Preferences/com.apple.finder.plist

# Use current directory as default search scope in Finder
# sudo -u "$CURRENT_USER" defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show hard drives and network drives on the Desktop
# sudo -u "$CURRENT_USER" defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# sudo -u "$CURRENT_USER" defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

###################
# SYSTEM SETTINGS #
###################

# Beep feedback when changing volume
sudo -u "$CURRENT_USER" defaults write NSGlobalDomain com.apple.sound.beep.feedback -integer 1

# Beep feedback when plugging in the power adapter
sudo -u "$CURRENT_USER" defaults write com.apple.PowerChime ChimeOnAllHardware -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
sudo -u "$CURRENT_USER" defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Expand save panel by default
sudo -u "$CURRENT_USER" defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable Force Click / Force Touch
sudo -u "$CURRENT_USER" defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -int 1

# Enable two buttons / secondary / right click on Magic Mouses
sudo -u "$CURRENT_USER" defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"
sudo -u "$CURRENT_USER" defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Prevent Photos.app from opening when a device is plugged
sudo -u "$CURRENT_USER" defaults write com.apple.ImageCapture disableHotPlug -bool yes

# Disable Bluetooth when it is a laptop
LAPTOPMODEL=$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/grep "Model Name" | /usr/bin/grep "Book" | /usr/bin/awk -F ": " '{print $2}')
echo "$LAPTOPMODEL"
if [ -z "$LAPTOPMODEL" ]; then
	defaults write com.apple.BTServer defaultPoweredState -string "on"
else
	defaults write com.apple.BTServer defaultPoweredState -string "off"
fi

# Disable shadows on screenshots
sudo -u "$CURRENT_USER" defaults write com.apple.screencapture disable-shadow -bool true

# Enable automatic updates
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true

# Change Terminal settings
sudo -u "$CURRENT_USER" defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
sudo -u "$CURRENT_USER" defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"
sudo -u "$CURRENT_USER" /usr/libexec/PlistBuddy -c "Add :'Window Settings':'Pro':'CursorBlink' bool true" /Users/"$CURRENT_USER"/Library/Preferences/com.apple.Terminal.plist
sudo -u "$CURRENT_USER" /usr/libexec/PlistBuddy -c "Set :'Window Settings':'Pro':'CursorBlink' 'true'" /Users/"$CURRENT_USER"/Library/Preferences/com.apple.Terminal.plist

# Startup Chime / StartupMute=%01 to mute
nvram StartupMute=%00

# Disable auto startup when opening the lid. AutoBoot=%03 to turn it back on
# nvram AutoBoot=%00

# Enable location services
defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1
launchctl kickstart -k system/com.apple.locationd

# Configure automatic timezone
defaults write /Library/Preferences/com.apple.timezone.auto Active -bool YES
defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeOnlyEnabled -bool YES
defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeZoneEnabled -bool YES

# Set time, date, timezone automatically using current location
/usr/sbin/systemsetup -setusingnetworktime on
/usr/sbin/systemsetup -gettimezone
/usr/sbin/systemsetup -getnetworktimeserver

# Set timezone manually · Use /usr/sbin/systemsetup -listtimezones
# /usr/sbin/systemsetup -settimezone America/New_York

# Safari : show bookmarks bar and status bar
launchctl asuser "$USER_ID" sudo -u "$CURRENT_USER" defaults write com.apple.Safari ShowFavoritesBar-v2 -bool true
launchctl asuser "$USER_ID" sudo -u "$CURRENT_USER" defaults write com.apple.Safari ShowOverlayStatusBar -bool true

# Google Chrome : Force relaunch (in milliseconds) when there is a pending update  + Home button
launchctl asuser "$USER_ID" sudo -u "$CURRENT_USER" defaults write com.google.Chrome RelaunchNotification -int 2
launchctl asuser "$USER_ID" sudo -u "$CURRENT_USER" defaults write com.google.Chrome RelaunchNotificationPeriod -int 21600000
launchctl asuser "$USER_ID" sudo -u "$CURRENT_USER" defaults write com.google.Chrome ShowHomeButton -bool true

# Remove Wi-Fi SSID from known networks. Ex: forget the Wi-Fi dedicated to Mac enrollments
for interface in $(networksetup -listnetworkserviceorder | grep Hardware | awk '/Wi-Fi/ { print $NF }' | awk -F ")" '{ print $1 }'); do
	echo "Disconnecting $interface from non-internal device network"
	networksetup -removepreferredwirelessnetwork $interface "NAME_OF_SSID"
done

# Activity Monitor : Show Data in graph instead of IO and packets
sudo -u "$CURRENT_USER" defaults write com.apple.ActivityMonitor DiskGraphType -int 1
sudo -u "$CURRENT_USER" defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

# Uncheck 'Reopen Windows When Logging Back'
sudo -u "$CURRENT_USER" defaults write com.apple.loginwindow TALLogoutSavesState -bool false

# Enable Firewall
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Disable Bonjour Advertising Service. Doesn't affect AirDrop. Final Cut Studio and AirPort Base Station management may not operate properly.
defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable Power Nap & Wake for Network Access
pmset -a powernap 0
pmset -a womp 0

# Touch Bar shows Expanded Control Strip
sudo -u "$CURRENT_USER" defaults write com.apple.touchbar.agent PresentationModeGlobal -string "fullControlStrip"

# Touch ID for sudo commands in Terminal · Ventura + Monterey Edition
sed -i '.bak' '2s/^/auth       sufficient     pam_tid.so\'$'\n/g' /private/etc/pam.d/sudo

# Touch ID for sudo commands in Terminal · Sonoma Editon
#cp /private/etc/pam.d/sudo_local.template /private/etc/pam.d/sudo_local
#sed -i '.bak' '3s/#//' "/private/etc/pam.d/sudo_local"

# Remove login items
# sudo -u "$CURRENT_USER" /usr/bin/osascript -e 'tell application "System Events" to delete login item "Skype for Business"'

# Set Slack workspace ID : https://docs.louply.io/how-tos/how_to_get_slack_workspace_id/
# sudo -u "$CURRENT_USER" defaults write com.tinyspeck.slackmacgap SlackDefaultSignInWorkspace -string 'ABCD1234'

################
# LOGIN SCREEN #
################

# Show language menu in the top right corner of the boot screen
defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Show IP when clicking on clock
defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Set the picture of your admin account · Picture by https://basicappleguy.com
curl -o "/Users/Shared/admin.png" "https://i.imgur.com/xuyelkU.png"
dscl . delete /Users/yourAdminAccount jpegphoto
dscl . delete /Users/yourAdminAccount Picture
dscl . create /Users/yourAdminAccount Picture "/Users/Shared/admin.png"

# Set the picture of the current user · Picture by https://basicappleguy.com
curl -o "/Users/Shared/user.png" "https://i.imgur.com/crrUCrM.png"
dscl . delete /Users/"$CURRENT_USER" jpegphoto
dscl . delete /Users/"$CURRENT_USER" Picture
dscl . create /Users/"$CURRENT_USER" Picture "/Users/Shared/user.png"

# Disable password hints
defaults write com.apple.loginwindow RetriesUntilHint -int 0

##############################
# UNLOCKS FOR NON-ADMIN USER #
##############################

# Unlock System Preferences for non admins
security authorizationdb write system.preferences allow
security authorizationdb write system.settings allow

# Unlock Date and Time
security authorizationdb write system.preferences.datetime allow
security authorizationdb write system.settings.datetime allow

# Unlock Energy Saver preference pane
security authorizationdb write system.preferences.energysaver allow
security authorizationdb write system.settings.energysaver allow

# Unlock Network preference pane
security authorizationdb write system.preferences.network allow
security authorizationdb write system.settings.network allow
security authorizationdb write system.services.systemconfiguration.network allow
/usr/libexec/airportd prefs RequireAdminNetworkChange=NO RequireAdminIBSS=NO

# Unlock Time Machine preference pane
security authorizationdb write system.preferences.timemachine allow
security authorizationdb write system.settings.timemachine allow

# Unlock Print & Scan Preference pane
security authorizationdb write system.preferences.printing allow
security authorizationdb write system.settings.printing allow

# Give Everyone Print Operator Access
dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin

####################
# RESTART SERVICES #
####################

killall cfprefsd
killall SystemUIServer
killall -HUP bluetoothd
killall ControlStrip
killall Finder
killall Dock

exit 0
