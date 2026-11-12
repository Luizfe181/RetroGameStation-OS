#!/usr/bin/env bash
#
# .bashrc for RetroGameStation gamer user
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source retrodev environment
if [ -f /etc/profile.d/retrodev-env.sh ]; then
    . /etc/profile.d/retrodev-env.sh
fi

# User specific aliases and functions
alias ls='lsd --group-dirs=first'
alias ll='lsd -la --group-dirs=first'
alias lt='lsd --tree --group-dirs=first'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias top='btop'
alias ps='procs'
alias df='duf'
alias du='dust'
alias diff='delta'
alias vim='nvim'
alias vi='nvim'
alias code='code --ozone-platform=wayland'
alias git='hub'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'

# Retrodev aliases
alias ps2env='module load retrodev/ps2sdk'
alias ppcenv='module load retrodev/devkitppc'
alias ardenv='module load retrodev/devkitarm'
alias nxenv='module load retrodev/libnx'
alias retrodev-list='module avail retrodev/'

# Gaming aliases
alias steam='gamescope -W 1920 -H 1080 -r 60 -f -F fsr -S 0.5 -- steam -tenfoot -steamos3 -steamdeck'
alias steam-desktop='steam'
alias mangohud='mangohud --gpu-stats --cpu-stats --ram --vram --fps --frame-timing'

# Build aliases
alias cmake-ps2='cmake -DCMAKE_TOOLCHAIN_FILE=/opt/ps2sdk/cmake/PS2.cmake'
alias cmake-ppc='cmake -DCMAKE_TOOLCHAIN_FILE=/opt/devkitpro/devkitPPC.cmake'
alias cmake-arm='cmake -DCMAKE_TOOLCHAIN_FILE=/opt/devkitpro/devkitARM.cmake'
alias cmake-nx='cmake -DCMAKE_TOOLCHAIN_FILE=/opt/libnx/cmake/Switch.cmake'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Directory shortcuts
alias dev='cd ~/Development'
alias games='cd ~/Games'
alias retrodev='cd ~/RetroDev'
alias downloads='cd ~/Downloads'

# System shortcuts
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rs'
alias orphan='sudo pacman -Rns $(pacman -Qtdq)'
alias clean='sudo pacman -Sc'
alias aur='yay -S'

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dlogs='docker logs'
alias dexec='docker exec -it'

# Kubernetes shortcuts
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'

# Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a new retrodev project
new-retrodev-project() {
    local name="$1"
    local platform="${2:-ps2}"
    
    if [ -z "$name" ]; then
        echo "Usage: new-retrodev-project <name> [ps2|ppc|arm|3ds|nx|psp|vita|n64|dc|saturn|ps1]"
        return 1
    fi
    
    mkdir -p "$name"
    cd "$name"
    
    case "$platform" in
        ps2)
            cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MyPS2Project C CXX ASM)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER ee-gcc)
set(CMAKE_CXX_COMPILER ee-g++)
set(CMAKE_ASM_COMPILER ee-gcc)

include(/opt/ps2sdk/cmake/PS2.cmake)

add_executable(${PROJECT_NAME}.elf src/main.c)
target_link_libraries(${PROJECT_NAME}.ELF ${PS2SDK_LIBS})
EOF
            mkdir -p src
            cat > src/main.c << 'EOF'
#include <stdio.h>
#include <kernel.h>
#include <sifrpc.h>
#include <loadfile.h>
#include <debug.h>

int main(int argc, char *argv[]) {
    SifInitRpc(0);
    init_scr();
    printf("Hello PS2!\n");
    SleepThread();
    return 0;
}
EOF
            ;;
        ppc)
            cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MyWiiProject C CXX)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER powerpc-eabi-gcc)
set(CMAKE_CXX_COMPILER powerpc-eabi-g++)

include(/opt/devkitpro/devkitPPC.cmake)

add_executable(${PROJECT_NAME}.elf src/main.c)
target_link_libraries(${PROJECT_NAME}.elf ${LIBOGC_LIBS})
EOF
            mkdir -p src
            cat > src/main.c << 'EOF'
#include <stdio.h>
#include <gccore.h>
#include <wiiuse/wpad.h>

int main(int argc, char **argv) {
    VIDEO_Init();
    WPAD_Init();
    
    printf("Hello Wii/GameCube!\n");
    
    while(1) {
        WPAD_ScanPads();
        u32 pressed = WPAD_ButtonsDown(0);
        if (pressed & WPAD_BUTTON_HOME) break;
        VIDEO_WaitVSync();
    }
    
    return 0;
}
EOF
            ;;
        arm)
            cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MyNDSProject C CXX)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)

include(/opt/devkitpro/devkitARM.cmake)

add_executable(${PROJECT_NAME}.nds src/main.c)
target_link_libraries(${PROJECT_NAME}.nds ${LIBNDS_LIBS})
EOF
            mkdir -p src
            cat > src/main.c << 'EOF'
#include <nds.h>
#include <stdio.h>

int main(void) {
    consoleDemoInit();
    printf("Hello Nintendo DS!\n");
    
    while(1) {
        swiWaitForVBlank();
        scanKeys();
        if (keysDown() & KEY_START) break;
    }
    
    return 0;
}
EOF
            ;;
        nx)
            cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.16)
project(MySwitchProject C CXX)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER aarch64-none-elf-gcc)
set(CMAKE_CXX_COMPILER aarch64-none-elf-g++)

include(/opt/libnx/cmake/Switch.cmake)

add_executable(${PROJECT_NAME}.nro src/main.c)
target_link_libraries(${PROJECT_NAME}.nro ${LIBNX_LIBS})
EOF
            mkdir -p src
            cat > src/main.c << 'EOF'
#include <switch.h>
#include <stdio.h>

int main(int argc, char **argv) {
    consoleInit(NULL);
    printf("Hello Nintendo Switch!\n");
    
    while(appletMainLoop()) {
        hidScanInput();
        u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
        if (kDown & KEY_PLUS) break;
        consoleUpdate(NULL);
    }
    
    consoleExit(NULL);
    return 0;
}
EOF
            ;;
        *)
            echo "Unknown platform: $platform"
            return 1
            ;;
    esac
    
    echo "Created $platform project in $name"
}

# Show system info
sysinfo() {
    echo "=== RetroGameStation System Info ==="
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Arch: $(uname -m)"
    echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo "GPU: $(lspci | grep -i vga | cut -d':' -f3 | xargs)"
    echo "Memory: $(free -h | grep Mem | awk '{print $2}')"
    echo "Disk: $(df -h / | tail -1 | awk '{print $2}')"
    echo ""
    echo "=== Retrodev Toolchains ==="
    for tool in ee-gcc ppc-eabi-gcc arm-none-eabi-gcc mips64-elf-gcc sh-elf-gcc riscv64-elf-gcc aarch64-none-elf-gcc; do
        if command -v $tool &>/dev/null; then
            echo "✓ $tool: $($tool --version | head -1)"
        else
            echo "✗ $tool: Not installed"
        fi
    done
}

# Prompt
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Welcome message
if [ -t 1 ]; then
    echo -e "\033[0;36m"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════╗
    ║                  RetroGameStation                            ║
    ║         Hybrid Gaming + Retroconsole Development             ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "\033[0m"
    echo "Type 'sysinfo' for system information"
    echo "Type 'new-retrodev-project <name> <platform>' to create a project"
    echo "Platforms: ps2, ppc, arm, nx, psp, vita, n64, dc, saturn, ps1"
    echo ""
fi