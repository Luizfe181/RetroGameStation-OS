#!/usr/bin/env bash
#
# .profile for RetroGameStation gamer user
#

# Source retrodev environment
if [ -f /etc/profile.d/retrodev-env.sh ]; then
    . /etc/profile.d/retrodev-env.sh
fi

# User specific environment
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.go/bin:$PATH"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="konsole"
export BROWSER="firefox"
export FILE_MANAGER="dolphin"

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Gaming
export STEAM_DECK=1
export STEAMOS=1
export STEAMOS_SESSION=gamescope
export GAMESCOPE_RESOLUTION=1920x1080
export GAMESCOPE_REFRESH=60

# Retrodev
export PS2SDK=/opt/ps2sdk
export DEVKITPRO=/opt/devkitpro
export DEVKITPPC=/opt/devkitpro/devkitPPC
export DEVKITARM=/opt/devkitpro/devkitARM
export LIBNX=/opt/libnx

# Wayland
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_DISPLAY=wl
export MOZ_ENABLE_WAYLAND=1

# Vulkan
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json:/usr/share/vulkan/icd.d/intel_icd.x86_64.json
export VK_LAYER_PATH=/usr/share/vulkan/explicit_layer.d:/usr/share/vulkan/implicit_layer.d

# Localization
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8
export LANGUAGE=pt_BR:pt:en

# Load .bashrc if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi