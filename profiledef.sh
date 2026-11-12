#!/usr/bin/env bash
#
# profiledef.sh - Archiso profile definition for RetroGameStation
# Distro híbrida: Gaming (SteamOS/Gamescope) + Retroconsole Development
#

# Profile metadata
iso_name="retrogamestation"
iso_label="RETROGAMESTATION_$(date +%Y%m)"
iso_publisher="RetroGameStation <https://github.com/retrogamestation>"
iso_application="RetroGameStation - Hybrid Gaming & Retrodev Live/Install ISO"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"

# Overlay directories
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19' '-b' '1M')

# Kernel and bootloader
kernel_packages=('linux' 'linux-firmware' 'linux-headers')

# Profile packages directory
packages_dir="packages"

# File permissions override
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/usr/local/bin/retrogame-setup"]="0:0:755"
  ["/usr/local/bin/setup-local-repo"]="0:0:755"
  ["/usr/local/bin/retrodev-env"]="0:0:755"
  ["/usr/local/bin/retrodev-install"]="0:0:755"
  ["/usr/local/bin/retrodev-clone"]="0:0:755"
  ["/usr/local/bin/session-switch"]="0:0:755"
)

# Systemd services to enable
systemd_services=(
  'NetworkManager.service'
  'bluetooth.service'
  'steam-firstboot.service'
  'gamescope-session.service'
  'retrodev-env-setup.service'
  'retrogamestation-boot-video.service'
  'activate-graphical.target.service'
)

# Profile-specific settings
profile_name="retrogamestation"
profile_description="Hybrid Gaming & Retroconsole Development Station"
profile_homepage="https://github.com/retrogamestation"
profile_documentation="https://wiki.retrogamestation.org"

# Custom installer settings (if using calamares or archinstall)
installer_enabled=true
installer_config="installer-config.yaml"

# Gamescope/Steam session configuration
gamescope_session_user="gamer"
gamescope_session_autologin=true

# Retrodev toolchains paths
PS2SDK_PATH="/opt/ps2sdk"
DEVKITPRO_PATH="/opt/devkitpro"
DEVKITARM_PATH="/opt/devkitpro/devkitARM"
DEVKITPPC_PATH="/opt/devkitpro/devkitPPC"