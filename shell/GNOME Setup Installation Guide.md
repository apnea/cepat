# GNOME Setup Installation Guide for Ubuntu Server

## Prerequisites
```bash
# Install GNOME Desktop on Ubuntu Server
sudo apt update
sudo apt install ubuntu-desktop-minimal
# OR for full desktop: sudo apt install gnome-shell
```

## Essential Extensions

### Install GNOME Extensions Support
```bash
# Install extension manager and browser integration
sudo apt install gnome-shell-extensions chrome-gnome-shell
sudo apt install gnome-shell-extension-manager

# Install via Firefox/Chrome extension or command line
```

### Required Extensions
Install these via GNOME Extensions website or extension manager:

1. **User Theme Support** (built-in)
   - Already included in gnome-shell-extensions

2. **AppIndicator Support**
   ```bash
   sudo apt install gnome-shell-extension-appindicator
   ```

3. **Just Perfection**
   - Install from: https://extensions.gnome.org/extension/3843/just-perfection/

4. **Rounded Window Corners**
   - Install from: https://extensions.gnome.org/extension/5237/rounded-window-corners/
   - Alternative: https://extensions.gnome.org/extension/1514/rounded-corners/

5. **GSConnect (KDE Connect)**
   ```bash
   sudo apt install gnome-shell-extension-gsconnect
   ```

6. **Fullscreen Avoider**
   - Install from: https://extensions.gnome.org/extension/4362/fullscreen-avoider/

## Themes Installation

### WhiteSur Theme
```bash
# Install dependencies
sudo apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc

# Clone and install WhiteSur theme
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme

# Install the Nordic variant
./install.sh -c Dark -t orange -N glassy
# This creates WhiteSur-Dark-nord theme

# Install shell theme
./tweaks.sh -g -o normal
```

### Nordzy Icon Theme
```bash
# Install Nordzy icons
git clone https://github.com/alvatip/Nordzy-icon.git
cd Nordzy-icon
./install.sh -t dark -c light
# This installs Nordzy-dark--light_panel
```

### Sunity Cursor Theme
```bash
# Download and install Sunity cursors
wget https://github.com/alvatip/Sunity-cursor/releases/latest/download/Sunity-cursors.tar.gz
tar -xf Sunity-cursors.tar.gz
mkdir -p ~/.icons
mv Sunity-cursors* ~/.icons/
```

## Font Installation

### Popular Font Families
```bash
# Install common fonts
sudo apt install fonts-dejavu fonts-liberation fonts-noto
sudo apt install fonts-firacode fonts-jetbrains-mono

# Install additional Google fonts
sudo apt install fonts-roboto fonts-open-sans

# For designer fonts (Abel, Bebas Neue):
sudo apt install fonts-gfs-neohellenic fonts-wine
```

## Configuration Commands

### Apply Themes
```bash
# Set GTK theme
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark-nord'

# Set shell theme (requires User Themes extension)
gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark-nord'

# Set icon theme
gsettings set org.gnome.desktop.interface icon-theme 'Nordzy-dark--light_panel'

# Set cursor theme
gsettings set org.gnome.desktop.interface cursor-theme 'Sunity-cursors'

# Set dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### Enable Extensions
```bash
# Enable extensions (run after installing each)
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable just-perfection-desktop@just-perfection
gnome-extensions enable rounded-window-corners@yilozt
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable fullscreen-avoider@noobsai.github.com
```

## Alternative Installation Methods

### Via GNOME Tweaks
```bash
# Install GNOME Tweaks for GUI theme management
sudo apt install gnome-tweaks

# Use Tweaks to:
# - Appearance tab: Set themes and icons
# - Extensions tab: Manage extensions
# - Fonts tab: Configure fonts
```

### Via Extension Manager
```bash
# Modern extension manager
flatpak install flathub com.mattjakeman.ExtensionManager
```

## Troubleshooting

### If Extensions Don't Load
```bash
# Restart GNOME Shell
Alt + F2, type 'r', press Enter

# Or logout/login
```

### Missing Dependencies
```bash
# Install build dependencies for themes
sudo apt install meson ninja-build libglib2.0-dev-bin
```

### Font Issues
```bash
# Refresh font cache
sudo fc-cache -fv
```

## Post-Installation

1. **Reboot** to ensure all changes take effect
2. **Open GNOME Tweaks** to verify theme application
3. **Configure extensions** via Extensions app or website preferences
4. **Set custom wallpaper** matching your Nordic theme
