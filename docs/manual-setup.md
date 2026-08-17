# Manual setup

Bootstrap intentionally leaves human-only and privileged operations visible:

- Sign in to 1Password and enable CLI integration.
- Confirm Git SSH signing works through 1Password.
- Sign in to the Mac App Store before installing `mas` entries.
- Sign in to licensed applications and grant required Accessibility, Input Monitoring, Screen Recording, microphone, and automation permissions.
- Select any desired Dock, Mission Control, Finder, Calendar, Alfred, and Spotlight preferences not covered by `scripts/macos-defaults`.
- Configure iCloud Drive or other cloud storage before redirecting user folders manually.
- Configure privileged security settings individually after reviewing their current macOS behavior.

The old macOS script changed the firewall, multicast advertising, power management, PAM, location services, login-window behavior, and account images. Those operations are deliberately not automated by this repository.
