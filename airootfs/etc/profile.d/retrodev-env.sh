#!/usr/bin/env bash
#
# retrodev-env.sh - Environment variables for retroconsole development toolchains
# Sourced by /etc/profile.d/retrodev-env.sh and systemd services
#

# =============================================================================
# PS2 DEVELOPMENT (PS2SDK)
# =============================================================================
export PS2SDK="/opt/ps2sdk"
export PS2DEV="/opt/ps2dev"
export PS2TOOLCHAIN="/opt/ps2toolchain"
export PS2CLIENT="/opt/ps2client"
export PS2LINK="/opt/ps2link"
export PS2NETFS="/opt/ps2netfs"
export PS2PM="/opt/ps2pm"
export PS2VFS="/opt/ps2vfs"
export GSKIT="/opt/ps2sdk/gsKit"
export PS2SDK_PORTS="/opt/ps2sdk/ports"

# PS2 SDK paths
export PATH="${PS2SDK}/bin:${PS2DEV}/bin:${PS2TOOLCHAIN}/bin:${PATH}"
export C_INCLUDE_PATH="${PS2SDK}/ee/include:${PS2SDK}/common/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${PS2SDK}/ee/include:${PS2SDK}/common/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${PS2SDK}/ee/lib:${PS2SDK}/common/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${PS2SDK}/ee/lib:${PS2SDK}/common/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PS2SDK}/ee/lib/pkgconfig:${PS2SDK}/common/lib/pkgconfig:${PKG_CONFIG_PATH}"

# =============================================================================
# GAMECUBE/WII DEVELOPMENT (DEVKITPPC)
# =============================================================================
export DEVKITPRO="/opt/devkitpro"
export DEVKITPPC="/opt/devkitpro/devkitPPC"
export LIBOGC="/opt/devkitpro/libogc"
export PORTLIBS_PPC="/opt/devkitpro/portlibs/ppc"

export PATH="${DEVKITPPC}/bin:${PATH}"
export C_INCLUDE_PATH="${LIBOGC}/include:${PORTLIBS_PPC}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${LIBOGC}/include:${PORTLIBS_PPC}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${LIBOGC}/lib/wii:${LIBOGC}/lib/cube:${PORTLIBS_PPC}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${LIBOGC}/lib/wii:${LIBOGC}/lib/cube:${PORTLIBS_PPC}/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PORTLIBS_PPC}/lib/pkgconfig:${PKG_CONFIG_PATH}"

# Wii/GameCube specific
export WII_ROOT="${LIBOGC}"
export GAMECUBE_ROOT="${LIBOGC}"

# =============================================================================
# GBA/NDS DEVELOPMENT (DEVKITARM)
# =============================================================================
export DEVKITARM="/opt/devkitpro/devkitARM"
export LIBNDS="/opt/devkitpro/libnds"
export LIBGBA="/opt/devkitpro/libgba"
export LIBFAT="/opt/devkitpro/libfat"
export DSWIFI="/opt/devkitpro/dswifi"
export MAXMOD="/opt/devkitpro/maxmod"
export TONCLIB="/opt/devkitpro/tonclib"
export GRIT="/opt/devkitpro/grit"
export MMUTIL="/opt/devkitpro/mmutil"
export LIBLCF="/opt/devkitpro/liblcf"
export PORTLIBS_ARM="/opt/devkitpro/portlibs/arm"

export PATH="${DEVKITARM}/bin:${PATH}"
export C_INCLUDE_PATH="${LIBNDS}/include:${LIBGBA}/include:${LIBFAT}/include:${PORTLIBS_ARM}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${LIBNDS}/include:${LIBGBA}/include:${LIBFAT}/include:${PORTLIBS_ARM}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${LIBNDS}/lib:${LIBGBA}/lib:${LIBFAT}/lib:${PORTLIBS_ARM}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${LIBNDS}/lib:${LIBGBA}/lib:${LIBFAT}/lib:${PORTLIBS_ARM}/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PORTLIBS_ARM}/lib/pkgconfig:${PKG_CONFIG_PATH}"

# =============================================================================
# 3DS DEVELOPMENT
# =============================================================================
export CTRULIB="/opt/devkitpro/ctru"
export CITRO3D="/opt/devkitpro/citro3d"
export CITRO2D="/opt/devkitpro/citro2d"
export SF2DLIB="/opt/devkitpro/sf2dlib"
export CPP3DS="/opt/devkitpro/cpp3ds"
export PORTLIBS_3DS="/opt/devkitpro/portlibs/3ds"

export C_INCLUDE_PATH="${CTRULIB}/include:${CITRO3D}/include:${CITRO2D}/include:${PORTLIBS_3DS}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${CTRULIB}/include:${CITRO3D}/include:${CITRO2D}/include:${PORTLIBS_3DS}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${CTRULIB}/lib:${CITRO3D}/lib:${CITRO2D}/lib:${PORTLIBS_3DS}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${CTRULIB}/lib:${CITRO3D}/lib:${CITRO2D}/lib:${PORTLIBS_3DS}/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PORTLIBS_3DS}/lib/pkgconfig:${PKG_CONFIG_PATH}"

# =============================================================================
# DREAMCAST DEVELOPMENT (KOS)
# =============================================================================
export KOS_BASE="/opt/kos"
export KOS_PORTS="/opt/kos-ports"
export KOS_UTILS="/opt/kos-utils"
export PATH="${KOS_BASE}/utils/bin:${KOS_PORTS}/utils/bin:${PATH}"
export C_INCLUDE_PATH="${KOS_BASE}/include:${KOS_PORTS}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${KOS_BASE}/include:${KOS_PORTS}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${KOS_BASE}/lib:${KOS_PORTS}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${KOS_BASE}/lib:${KOS_PORTS}/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${KOS_PORTS}/lib/pkgconfig:${PKG_CONFIG_PATH}"

# =============================================================================
# SATURN DEVELOPMENT
# =============================================================================
export SATURN_DEV="/opt/saturn-dev"
export SATURN_ORB="/opt/saturn-orb"
export SATURN_SGL="/opt/saturn-sgl"
export SATURN_SBL="/opt/saturn-sbl"
export PATH="${SATURN_DEV}/bin:${SATURN_ORB}/bin:${PATH}"
export C_INCLUDE_PATH="${SATURN_DEV}/include:${SATURN_ORB}/include:${SATURN_SGL}/include:${SATURN_SBL}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${SATURN_DEV}/include:${SATURN_ORB}/include:${SATURN_SGL}/include:${SATURN_SBL}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${SATURN_DEV}/lib:${SATURN_ORB}/lib:${SATURN_SGL}/lib:${SATURN_SBL}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${SATURN_DEV}/lib:${SATURN_ORB}/lib:${SATURN_SGL}/lib:${SATURN_SBL}/lib:${LD_LIBRARY_PATH}"

# =============================================================================
# PS1 DEVELOPMENT (PSYQ/PSn00bSDK)
# =============================================================================
export PSYQ="/opt/psyq"
export PSN00BSDK="/opt/psn00bsdk"
export PSXSDK="/opt/psxsdk"
export PATH="${PSYQ}/bin:${PSN00BSDK}/bin:${PSXSDK}/bin:${PATH}"
export C_INCLUDE_PATH="${PSYQ}/include:${PSN00BSDK}/include:${PSXSDK}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${PSYQ}/include:${PSN00BSDK}/include:${PSXSDK}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${PSYQ}/lib:${PSN00BSDK}/lib:${PSXSDK}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${PSYQ}/lib:${PSN00BSDK}/lib:${PSXSDK}/lib:${LD_LIBRARY_PATH}"

# =============================================================================
# N64 DEVELOPMENT (LIBDRAGON)
# =============================================================================
export LIBDRAGON="/opt/libdragon"
export N64CHAIN="/opt/n64chain"
export N64SDK="/opt/n64sdk"
export PATH="${LIBDRAGON}/bin:${N64CHAIN}/bin:${N64SDK}/bin:${PATH}"
export C_INCLUDE_PATH="${LIBDRAGON}/include:${N64SDK}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${LIBDRAGON}/include:${N64SDK}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${LIBDRAGON}/lib:${N64SDK}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${LIBDRAGON}/lib:${N64SDK}/lib:${LD_LIBRARY_PATH}"

# =============================================================================
# PSP DEVELOPMENT
# =============================================================================
export PSPSDK="/opt/pspsdk"
export PSPDEV="/opt/pspdev"
export PSP_TOOLCHAIN="/opt/psp-toolchain"
export PSPLIBRARIES="/opt/psplibraries"
export PSPPLAYER="/opt/pspplayer"
export PSPGL="/opt/pspgl"
export PSPMP4="/opt/pspmp4"
export PSPAUDIO="/opt/pspaudio"
export PSPKERNEL="/opt/pspkernel"
export PSPDEBUG="/opt/pspdebug"
export PATH="${PSPSDK}/bin:${PSPDEV}/bin:${PSP_TOOLCHAIN}/bin:${PATH}"
export C_INCLUDE_PATH="${PSPSDK}/include:${PSPDEV}/include:${PSPLIBRARIES}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${PSPSDK}/include:${PSPDEV}/include:${PSPLIBRARIES}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${PSPSDK}/lib:${PSPDEV}/lib:${PSPLIBRARIES}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${PSPSDK}/lib:${PSPDEV}/lib:${PSPLIBRARIES}/lib:${LD_LIBRARY_PATH}"

# =============================================================================
# VITA DEVELOPMENT
# =============================================================================
export VITASDK="/opt/vitasdk"
export VITASHARK="/opt/vitashark"
export VITA2D="/opt/vita2d"
export PATH="${VITASDK}/bin:${PATH}"
export C_INCLUDE_PATH="${VITASDK}/include:${VITASHARK}/include:${VITA2D}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${VITASDK}/include:${VITASHARK}/include:${VITA2D}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${VITASDK}/lib:${VITASHARK}/lib:${VITA2D}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${VITASDK}/lib:${VITASHARK}/lib:${VITA2D}/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${VITASDK}/lib/pkgconfig:${PKG_CONFIG_PATH}"

# =============================================================================
# SWITCH DEVELOPMENT (LIBNX)
# =============================================================================
export LIBNX="/opt/libnx"
export SWITCH_DEV="/opt/switch-dev"
export SWITCH_TOOLS="/opt/switch-tools"
export MESA_NX="/opt/mesa-nx"
export LIBTRANSISTOR="/opt/libtransistor"
export PORTLIBS_SWITCH="/opt/devkitpro/portlibs/switch"

export PATH="${LIBNX}/bin:${SWITCH_DEV}/bin:${SWITCH_TOOLS}/bin:${DEVKITARM}/bin:${PATH}"
export C_INCLUDE_PATH="${LIBNX}/include:${MESA_NX}/include:${LIBTRANSISTOR}/include:${PORTLIBS_SWITCH}/include:${C_INCLUDE_PATH}"
export CPLUS_INCLUDE_PATH="${LIBNX}/include:${MESA_NX}/include:${LIBTRANSISTOR}/include:${PORTLIBS_SWITCH}/include:${CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="${LIBNX}/lib:${MESA_NX}/lib:${LIBTRANSISTOR}/lib:${PORTLIBS_SWITCH}/lib:${LIBRARY_PATH}"
export LD_LIBRARY_PATH="${LIBNX}/lib:${MESA_NX}/lib:${LIBTRANSISTOR}/lib:${PORTLIBS_SWITCH}/lib:${LD_LIBRARY_PATH}"
export PKG_CONFIG_PATH="${PORTLIBS_SWITCH}/lib/pkgconfig:${PKG_CONFIG_PATH}"

# =============================================================================
# GENERAL COMPILER SETTINGS
# =============================================================================
# Default to clang for better cross-compilation support
export CC="${CC:-clang}"
export CXX="${CXX:-clang++}"
export AR="${AR:-llvm-ar}"
export NM="${NM:-llvm-nm}"
export RANLIB="${RANLIB:-llvm-ranlib}"
export STRIP="${STRIP:-llvm-strip}"
export OBJCOPY="${OBJCOPY:-llvm-objcopy}"
export OBJDUMP="${OBJDUMP:-llvm-objdump}"
export READELF="${READELF:-llvm-readelf}"

# Parallel build jobs
export MAKEFLAGS="${MAKEFLAGS:--j$(nproc)}"
export CMAKE_BUILD_PARALLEL_LEVEL="${CMAKE_BUILD_PARALLEL_LEVEL:-$(nproc)}"
export NINJAJOBS="${NINJAJOBS:-$(nproc)}"

# =============================================================================
# REVERSE ENGINEERING TOOLS
# =============================================================================
export GHIDRA_INSTALL_DIR="/usr/share/ghidra"
export GHIDRA_SCRIPTS_DIR="${HOME}/.ghidra/scripts"
export RADARE2_HOME="${HOME}/.radare2"
export CUTTER_HOME="${HOME}/.cutter"
export IDA_PATH="/opt/ida"
export BINARYNINJA_PATH="/opt/binaryninja"
export ANGR_MANAGEMENT_HOME="${HOME}/.angr-management"
export PWNLIB_NOTERM=1

# =============================================================================
# EMULATOR CONFIGURATION
# =============================================================================
export PCSX2_HOME="${HOME}/.config/PCSX2"
export DUCKSTATION_HOME="${HOME}/.config/duckstation"
export RYUJINX_HOME="${HOME}/.config/Ryujinx"
export YUZU_HOME="${HOME}/.local/share/yuzu"
export CITRA_HOME="${HOME}/.config/citra"
export PPSSPP_HOME="${HOME}/.config/ppsspp"
export RPCS3_HOME="${HOME}/.config/rpcs3"
export DOLPHIN_HOME="${HOME}/.local/share/dolphin-emu"
export RETROARCH_HOME="${HOME}/.config/retroarch"
export RETROARCH_CORES_DIR="/usr/lib/libretro"
export RETROARCH_ASSETS_DIR="/usr/share/retroarch/assets"

# =============================================================================
# GAMING OPTIMIZATIONS
# =============================================================================
export MANGOHUD=1
export MANGOHUD_CONFIG="font_size=24,position=top-left,gpu_temp,vram,gpu_util,cpu_temp,cpu_util,ram,fps,frametime"
export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/radeon_icd.x86_64.json:/usr/share/vulkan/icd.d/intel_icd.x86_64.json"
export VK_LAYER_PATH="/usr/share/vulkan/explicit_layer.d:/usr/share/vulkan/implicit_layer.d"
export DXVK_ASYNC=1
export DXVK_HUD=0
export VKD3D_CONFIG="dxr11,multi_queue"
export VKD3D_SHADER_MODEL="6_6"
export PROTON_NO_ESYNC=0
export PROTON_NO_FSYNC=0
export gamemode="auto"

# =============================================================================
# STEAM/GAMESCOPE SETTINGS
# =============================================================================
export STEAM_FRAME_FORCE_CLOSE=1
export STEAM_DISABLE_GAMEPAD=0
export GAMESCOPE_RESOLUTION="1920x1080"
export GAMESCOPE_REFRESH="60"
export GAMESCOPE_HDR=0
export GAMESCOPE_DRM_FORMAT="XR24"
export GAMESCOPE_FILTER="fsr"
export GAMESCOPE_SHARPNESS="0.5"
export STEAM_DECK="1"
export STEAMOS=1
export STEAMOS_SESSION="gamescope"

# =============================================================================
# LOCALIZATION
# =============================================================================
export LANG="pt_BR.UTF-8"
export LC_ALL="pt_BR.UTF-8"
export LANGUAGE="pt_BR:pt:en"

# =============================================================================
# EDITOR & TOOLS
# =============================================================================
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="Catppuccin-mocha"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# =============================================================================
# PATH ADDITIONS
# =============================================================================
export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:${HOME}/.go/bin:/usr/local/bin:${PATH}"

# =============================================================================
# AUTO-COMPLETION
# =============================================================================
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# =============================================================================
# ALIASES FOR RETRODEV
# =============================================================================
alias ps2make='make -C ${PS2SDK}/samples'
alias ppcmake='cmake -DCMAKE_TOOLCHAIN_FILE=${DEVKITPPC}/cmake/DevkitPPC.cmake'
alias armmake='cmake -DCMAKE_TOOLCHAIN_FILE=${DEVKITARM}/cmake/DevkitARM.cmake'
alias kosmake='make -C ${KOS_BASE}/examples'
alias libdragonmake='make -C ${LIBDRAGON}/examples'
alias pspsdkmake='make -C ${PSPSDK}/samples'
alias vitasdkmake='make -C ${VITASDK}/samples'
alias libnxmake='make -C ${LIBNX}/examples'
alias switchmake='cmake -DCMAKE_TOOLCHAIN_FILE=${LIBNX}/cmake/Switch.cmake'

# Ghidra
alias ghidra='${GHIDRA_INSTALL_DIR}/ghidraRun'
alias ghidra-headless='${GHIDRA_INSTALL_DIR}/support/analyzeHeadless'

# Radare2
alias r2='radare2'
alias r2pm='r2pm'

# Emulators
alias pcsx2='pcsx2-qt'
alias duckstation='duckstation-qt'
alias ryujinx='ryujinx'
alias yuzu='yuzu'
alias citra='citra-qt'
alias ppsspp='ppsspp-qt'
alias rpcs3='rpcs3'
alias dolphin='dolphin-emu'
alias retroarch='retroarch'

# Gaming
alias steam-gamescope='gamescope -W 1920 -H 1080 -r 60 -f -- steam'
alias mangohud='mangohud --gpu-stats --cpu-stats --ram --vram --fps --frame-timing'

# Development
alias compile-commands='bear -- make'
alias cc='clang'
alias c++='clang++'