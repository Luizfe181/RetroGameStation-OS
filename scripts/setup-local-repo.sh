#!/usr/bin/env bash
#
# setup-local-repo.sh - Build local pacman repository for AUR and retrodev packages
# This script clones AUR packages, builds them, and creates a local pacman repository
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Default configuration
REPO_DIR="${HOME}/retrogamestation-local-repo"
REPO_NAME="retrogamestation-local"
BUILD_DIR="${REPO_DIR}/build"
PKG_DIR="${REPO_DIR}/packages"
SRC_DIR="${REPO_DIR}/sources"
JOBS=$(nproc)
VERBOSE=false
CLEAN_BUILD=false
ONLY_PACKAGES=()
SKIP_PACKAGES=()

# AUR packages for gaming
AUR_GAMING_PACKAGES=(
    "gamescope-session-steam-git"
    "proton-ge-custom"
    "protonup-qt"
    "heroic-games-launcher"
    "bottles"
    "lutris"
    "mangohud"
    "goverlay"
    "vkbasalt"
    "reshade"
    "dxvk-git"
    "vkd3d-git"
    "wine-gecko"
    "wine-mono"
    "winetricks-git"
    "steam-native-runtime"
    "steam-devices"
    "steam-controller"
    "inputplumber"
    "controller-support"
    "controller-support-udev"
    "cachyOS-gaming-meta"
)

# AUR packages for retrodev toolchains
AUR_RETODEV_PACKAGES=(
    # PS2 Development
    "ps2sdk-git"
    "ps2dev-git"
    "ps2toolchain-git"
    "ps2client-git"
    "ps2link-git"
    "ps2netfs-git"
    "ps2pm-git"
    "ps2vfs-git"
    
    # GameCube/Wii (devkitPPC)
    "devkitppc-git"
    "devkitppc-rules-git"
    "libogc-git"
    "libfat-ogc-git"
    "libpng-ogc-git"
    "zlib-ogc-git"
    "freetype-ogc-git"
    "libjpeg-ogc-git"
    "libogg-ogc-git"
    "libvorbis-ogc-git"
    "libmad-ogc-git"
    "libmodplug-ogc-git"
    "libmikmod-ogc-git"
    "libsmpeg-ogc-git"
    "libtheora-ogc-git"
    "libtiff-ogc-git"
    "libwebp-ogc-git"
    
    # GBA/NDS (devkitARM)
    "devkitarm-git"
    "devkitarm-rules-git"
    "libnds-git"
    "libgba-git"
    "libfat-git"
    "dswifi-git"
    "maxmod-git"
    "libtonc-git"
    "libgrit-git"
    "libmmutil-git"
    "liblcf-git"
    
    # 3DS
    "ctru-git"
    "citro3d-git"
    "citro2d-git"
    "libctru-git"
    "citro3d-git"
    "citro2d-git"
    "sf2dlib-git"
    "cpp3ds-git"
    
    # Dreamcast (KOS)
    "kos-git"
    "kos-ports-git"
    "kos-utils-git"
    
    # Saturn
    "saturn-dev-git"
    "saturn-orb-git"
    "saturn-sgl-git"
    "saturn-sbl-git"
    
    # PS1
    "psn00bsdk-git"
    "psyq-git"
    "psyq-sdk-git"
    "psxsdk-git"
    
    # N64 (libdragon)
    "libdragon-git"
    "libdragon-tools-git"
    "n64chain-git"
    "n64sdk-git"
    
    # PSP
    "pspsdk-git"
    "pspdev-git"
    "psp-toolchain-git"
    "psplibraries-git"
    "pspplayer-git"
    "pspgl-git"
    "pspmp4-git"
    "pspaudio-git"
    "pspkernel-git"
    "pspdebug-git"
    "pspsdk-stage1-git"
    "pspsdk-stage2-git"
    
    # Vita
    "vitasdk-git"
    "vitashark-git"
    "vita2d-git"
    "vitasdk-packages-git"
    
    # Switch (libnx)
    "libnx-git"
    "switch-dev-git"
    "switch-tools-git"
    "mesa-nx-git"
    "libtransistor-git"
)

# AUR packages for reverse engineering
AUR_RE_PACKAGES=(
    "ghidra-git"
    "ghidra-scripts"
    "radare2-git"
    "radare2-cutter-git"
    "ida-free"
    "binaryninja-git"
    "binaryninja-demo"
    "angr-git"
    "angr-management-git"
    "pwntools-git"
    "ropper-git"
    "ropgadget-git"
    "checksec-git"
    "frida-git"
    "frida-tools-git"
    "objection-git"
    "capstone-git"
    "keystone-git"
    "unicorn-git"
    "z3-git"
    "claripy-git"
    "cle-git"
    "pyvex-git"
    "archinfo-git"
    "binwalk-git"
    "firmware-mod-kit-git"
)

# AUR packages for emulators
AUR_EMULATOR_PACKAGES=(
    "pcsx2-git"
    "duckstation-git"
    "ryujinx-git"
    "yuzu-git"
    "yuzu-mainline-git"
    "yuzu-early-access-git"
    "citra-git"
    "citra-qt-git"
    "ppsspp-git"
    "rpcs3-git"
    "dolphin-emu-git"
    "mupen64plus-git"
    "parallel-n64-git"
    "ares-git"
    "beetle-psx-git"
    "mednafen-git"
    "mednaffe-git"
    "retroarch-git"
    "libretro-beetle-psx-git"
    "libretro-pcsx2-git"
    "libretro-dolphin-git"
    "libretro-mupen64plus-git"
    "libretro-parallel-n64-git"
    "libretro-ppsspp-git"
    "libretro-rpcs3-git"
    "libretro-snes9x-git"
    "libretro-mgba-git"
    "libretro-gambatte-git"
    "libretro-genesis-plus-gx-git"
    "libretro-fceumm-git"
    "libretro-nestopia-git"
    "libretro-vba-next-git"
    "libretro-desmume-git"
    "libretro-melonds-git"
    "libretro-citra-git"
    "libretro-flycast-git"
    "libretro-redream-git"
    "libretro-kronos-git"
    "libretro-yabause-git"
    "libretro-beetle-saturn-git"
    "libretro-beetle-lynx-git"
    "libretro-beetle-ngp-git"
    "libretro-beetle-pce-fast-git"
    "libretro-beetle-sgx-git"
    "libretro-beetle-wswan-git"
    "libretro-virtualjaguar-git"
    "libretro-opera-git"
    "libretro-vecx-git"
    "libretro-mame-git"
    "fbneo-git"
)

# All packages combined
ALL_PACKAGES=(
    "${AUR_GAMING_PACKAGES[@]}"
    "${AUR_RETODEV_PACKAGES[@]}"
    "${AUR_RE_PACKAGES[@]}"
    "${AUR_EMULATOR_PACKAGES[@]}"
)

# Help function
show_help() {
    cat << EOF
setup-local-repo.sh - Build local pacman repository for RetroGameStation

Usage: $0 [OPTIONS]

Options:
    -h, --help              Show this help
    -r, --repo-dir DIR      Repository directory (default: ~/retrogamestation-local-repo)
    -n, --repo-name NAME    Repository database name (default: retrogamestation-local)
    -j, --jobs N            Parallel build jobs (default: nproc)
    -v, --verbose           Verbose output
    -c, --clean             Clean build directory before building
    -p, --package PKG       Build only specific package (can be used multiple times)
    -s, --skip PKG          Skip specific package (can be used multiple times)
    --only-gaming           Build only gaming packages
    --only-retrodev         Build only retrodev toolchain packages
    --only-re               Build only reverse engineering packages
    --only-emulators        Build only emulator packages
    --list                  List all packages that would be built
    --no-build              Only download sources, don't build
    --no-repo               Don't create repository database

Examples:
    $0                      # Build all packages
    $0 --only-retrodev      # Build only retrodev toolchains
    $0 -p ps2sdk-git -p devkitarm-git  # Build specific packages
    $0 --list               # List all packages
    $0 -c -j 8              # Clean build with 8 jobs

EOF
}

# Print functions
print_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $*"; }
print_error() { echo -e "${RED}[ERROR]${NC} $*"; }
print_step() { echo -e "${MAGENTA}[STEP]${NC} $*"; }

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -r|--repo-dir)
                REPO_DIR="$2"
                BUILD_DIR="${REPO_DIR}/build"
                PKG_DIR="${REPO_DIR}/packages"
                SRC_DIR="${REPO_DIR}/sources"
                shift 2
                ;;
            -n|--repo-name)
                REPO_NAME="$2"
                shift 2
                ;;
            -j|--jobs)
                JOBS="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -c|--clean)
                CLEAN_BUILD=true
                shift
                ;;
            -p|--package)
                ONLY_PACKAGES+=("$2")
                shift 2
                ;;
            -s|--skip)
                SKIP_PACKAGES+=("$2")
                shift 2
                ;;
            --only-gaming)
                ALL_PACKAGES=("${AUR_GAMING_PACKAGES[@]}")
                shift
                ;;
            --only-retrodev)
                ALL_PACKAGES=("${AUR_RETODEV_PACKAGES[@]}")
                shift
                ;;
            --only-re)
                ALL_PACKAGES=("${AUR_RE_PACKAGES[@]}")
                shift
                ;;
            --only-emulators)
                ALL_PACKAGES=("${AUR_EMULATOR_PACKAGES[@]}")
                shift
                ;;
            --list)
                list_packages
                exit 0
                ;;
            --no-build)
                NO_BUILD=true
                shift
                ;;
            --no-repo)
                NO_REPO=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# List all packages
list_packages() {
    echo -e "${CYAN}Gaming Packages:${NC}"
    printf '  %s\n' "${AUR_GAMING_PACKAGES[@]}"
    echo ""
    echo -e "${CYAN}Retrodev Toolchains:${NC}"
    printf '  %s\n' "${AUR_RETODEV_PACKAGES[@]}"
    echo ""
    echo -e "${CYAN}Reverse Engineering:${NC}"
    printf '  %s\n' "${AUR_RE_PACKAGES[@]}"
    echo ""
    echo -e "${CYAN}Emulators:${NC}"
    printf '  %s\n' "${AUR_EMULATOR_PACKAGES[@]}"
    echo ""
    echo -e "${GREEN}Total: $((${#AUR_GAMING_PACKAGES[@]} + ${#AUR_RETODEV_PACKAGES[@]} + ${#AUR_RE_PACKAGES[@]} + ${#AUR_EMULATOR_PACKAGES[@]})) packages${NC}"
}

# Check if package should be built
should_build() {
    local pkg="$1"
    
    # Check skip list
    for skip in "${SKIP_PACKAGES[@]}"; do
        if [[ "$pkg" == "$skip" ]]; then
            return 1
        fi
    done
    
    # Check only list
    if [[ ${#ONLY_PACKAGES[@]} -gt 0 ]]; then
        for only in "${ONLY_PACKAGES[@]}"; do
            if [[ "$pkg" == "$only" ]]; then
                return 0
            fi
        done
        return 1
    fi
    
    return 0
}

# Setup directories
setup_dirs() {
    print_step "Setting up directories..."
    mkdir -p "$BUILD_DIR" "$PKG_DIR" "$SRC_DIR"
    print_success "Directories created at $REPO_DIR"
}

# Install base dependencies
install_base_deps() {
    print_step "Installing base dependencies..."
    local deps=("base-devel" "git" "python" "python-pip" "cmake" "ninja" "meson" "pkgconf" "fakeroot" "pacman-contrib" "repo-add" "repo-remove" "pacman" "devtools" "archiso")
    
    # Check if running as root or with sudo
    if [[ $EUID -eq 0 ]]; then
        pacman -Sy --needed --noconfirm "${deps[@]}"
    else
        sudo pacman -Sy --needed --noconfirm "${deps[@]}"
    fi
    
    print_success "Base dependencies installed"
}

# Clone or update AUR package
clone_aur_package() {
    local pkg="$1"
    local pkg_dir="${SRC_DIR}/${pkg}"
    
    if [[ -d "$pkg_dir" ]]; then
        print_info "Updating $pkg..."
        cd "$pkg_dir"
        git pull --quiet
    else
        print_info "Cloning $pkg..."
        git clone --quiet "https://aur.archlinux.org/${pkg}.git" "$pkg_dir"
    fi
}

# Build package
build_package() {
    local pkg="$1"
    local pkg_dir="${SRC_DIR}/${pkg}"
    local build_pkg_dir="${BUILD_DIR}/${pkg}"
    
    print_step "Building $pkg..."
    
    # Clean previous build
    rm -rf "$build_pkg_dir"
    mkdir -p "$build_pkg_dir"
    
    # Copy source
    cp -r "$pkg_dir"/* "$build_pkg_dir/"
    
    # Build package
    cd "$build_pkg_dir"
    
    # Check if PKGBUILD exists
    if [[ ! -f "PKGBUILD" ]]; then
        print_error "No PKGBUILD found for $pkg"
        return 1
    fi
    
    # Update pkgver if it's a git package
    if grep -q "pkgver()" PKGBUILD; then
        print_info "Updating pkgver for $pkg..."
        # Run pkgver() function
        # shellcheck source=/dev/null
        source PKGBUILD
        if declare -f pkgver &>/dev/null; then
            pkgver
        fi
    fi
    
    # Build with makepkg
    local makepkg_args=(-s --noconfirm --skippgpcheck)
    if [[ "$VERBOSE" == true ]]; then
        makepkg_args+=(-v)
    fi
    
    if makepkg "${makepkg_args[@]}"; then
        # Move built packages to repo
        find . -name "*.pkg.tar.zst" -exec mv {} "$PKG_DIR/" \;
        print_success "Built $pkg"
        return 0
    else
        print_error "Failed to build $pkg"
        return 1
    fi
}

# Create repository database
create_repo() {
    print_step "Creating repository database..."
    
    cd "$PKG_DIR"
    
    # Remove old database
    rm -f "${REPO_NAME}".db "${REPO_NAME}".files
    rm -f "${REPO_NAME}".db.tar.zst "${REPO_NAME}".files.tar.zst
    
    # Add all packages
    repo-add "${REPO_NAME}".db.tar.zst *.pkg.tar.zst
    
    print_success "Repository database created at $PKG_DIR/${REPO_NAME}.db.tar.zst"
}

# Main build loop
build_all() {
    local failed=()
    local success=()
    local skipped=()
    
    print_step "Starting build of ${#ALL_PACKAGES[@]} packages..."
    
    for pkg in "${ALL_PACKAGES[@]}"; do
        if ! should_build "$pkg"; then
            print_warning "Skipping $pkg (in skip list or not in only list)"
            skipped+=("$pkg")
            continue
        fi
        
        # Clone source
        if ! clone_aur_package "$pkg"; then
            print_error "Failed to clone $pkg"
            failed+=("$pkg")
            continue
        fi
        
        # Build if not --no-build
        if [[ "${NO_BUILD:-false}" != true ]]; then
            if build_package "$pkg"; then
                success+=("$pkg")
            else
                failed+=("$pkg")
            fi
        else
            print_info "Skipping build for $pkg (--no-build)"
        fi
    done
    
    # Summary
    echo ""
    print_step "Build Summary:"
    print_success "Successful: ${#success[@]}"
    if [[ ${#failed[@]} -gt 0 ]]; then
        print_error "Failed: ${#failed[@]}"
        for f in "${failed[@]}"; do
            print_error "  - $f"
        done
    fi
    if [[ ${#skipped[@]} -gt 0 ]]; then
        print_warning "Skipped: ${#skipped[@]}"
        for s in "${skipped[@]}"; do
            print_warning "  - $s"
        done
    fi
    
    # Create repo if not --no-repo
    if [[ "${NO_REPO:-false}" != true && ${#success[@]} -gt 0 ]]; then
        create_repo
    fi
    
    if [[ ${#failed[@]} -gt 0 ]]; then
        return 1
    fi
    return 0
}

# Main function
main() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║         RetroGameStation Local Repository Builder               ║
║              AUR + Retrodev Toolchains Repository               ║
╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    parse_args "$@"
    setup_dirs
    install_base_deps
    build_all
    
    print_success "Local repository setup completed!"
    print_info "Repository location: $PKG_DIR"
    print_info "Add to pacman.conf:"
    print_info "  [retrogamestation-local]"
    print_info "  SigLevel = Optional TrustAll"
    print_info "  Server = file://$PKG_DIR"
}

main "$@"