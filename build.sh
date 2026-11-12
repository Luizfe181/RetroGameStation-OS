#!/usr/bin/env bash
#
# build.sh - Build script for RetroGameStation ISO
# Usage: ./build.sh [options]
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="${SCRIPT_DIR}"
WORK_DIR="${SCRIPT_DIR}/work"
OUT_DIR="${SCRIPT_DIR}/out"
LOCAL_REPO_DIR="${SCRIPT_DIR}/packages/local"
LOCAL_REPO_DB="retrogamestation-local"

# Default options
BUILD_ISO=true
BUILD_LOCAL_REPO=true
CLEAN_WORK=false
CLEAN_OUT=false
VERBOSE=false
SIGN_ISO=false
GPG_KEY=""
PARALLEL_JOBS=$(nproc)

# Function to print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $*"; }
print_error() { echo -e "${RED}[ERROR]${NC} $*"; }
print_step() { echo -e "${MAGENTA}[STEP]${NC} $*"; }

# Help function
show_help() {
    cat << EOF
RetroGameStation ISO Build Script
=================================

Usage: $0 [OPTIONS]

Options:
    -h, --help              Show this help message
    -w, --work-dir DIR      Set work directory (default: ./work)
    -o, --out-dir DIR       Set output directory (default: ./out)
    -c, --clean-work        Clean work directory before build
    -C, --clean-out         Clean output directory before build
    -v, --verbose           Verbose output
    -s, --sign              Sign ISO with GPG key
    -k, --gpg-key KEY       GPG key ID for signing
    -j, --jobs N            Parallel jobs (default: nproc)
    --no-iso                Skip ISO build (only build local repo)
    --no-local-repo         Skip local repo build
    --only-local-repo       Only build local repository

Examples:
    $0                      # Build everything with defaults
    $0 -c -C                # Clean build
    $0 --only-local-repo    # Only build AUR/retrodev packages
    $0 --no-local-repo      # Build ISO without local repo (use prebuilt)
    $0 -s -k "Your Name"    # Build and sign ISO

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -w|--work-dir)
                WORK_DIR="$2"
                shift 2
                ;;
            -o|--out-dir)
                OUT_DIR="$2"
                shift 2
                ;;
            -c|--clean-work)
                CLEAN_WORK=true
                shift
                ;;
            -C|--clean-out)
                CLEAN_OUT=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -s|--sign)
                SIGN_ISO=true
                shift
                ;;
            -k|--gpg-key)
                GPG_KEY="$2"
                shift 2
                ;;
            -j|--jobs)
                PARALLEL_JOBS="$2"
                shift 2
                ;;
            --no-iso)
                BUILD_ISO=false
                shift
                ;;
            --no-local-repo)
                BUILD_LOCAL_REPO=false
                shift
                ;;
            --only-local-repo)
                BUILD_ISO=false
                BUILD_LOCAL_REPO=true
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

# Check dependencies
check_dependencies() {
    print_step "Checking dependencies..."
    
    local deps=("archiso" "git" "make" "pkgconf" "fakeroot" "pacman" "pacman-contrib")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_error "Missing dependencies: ${missing[*]}"
        print_info "Install with: sudo pacman -S ${missing[*]}"
        exit 1
    fi
    
    # Check for AUR helper
    if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
        print_warning "No AUR helper found (yay/paru). Will use makepkg directly."
    fi
    
    print_success "All dependencies satisfied"
}

# Clean directories
clean_directories() {
    if [[ "$CLEAN_WORK" == true && -d "$WORK_DIR" ]]; then
        print_step "Cleaning work directory..."
        rm -rf "$WORK_DIR"
        print_success "Work directory cleaned"
    fi
    
    if [[ "$CLEAN_OUT" == true && -d "$OUT_DIR" ]]; then
        print_step "Cleaning output directory..."
        rm -rf "$OUT_DIR"
        print_success "Output directory cleaned"
    fi
}

# Setup local repository for AUR/retrodev packages
build_local_repo() {
    if [[ "$BUILD_LOCAL_REPO" != true ]]; then
        print_info "Skipping local repository build"
        return 0
    fi
    
    print_step "Building local repository for AUR/retrodev packages..."
    
    # Run the local repo setup script
    if [[ -f "${SCRIPT_DIR}/scripts/setup-local-repo.sh" ]]; then
        bash "${SCRIPT_DIR}/scripts/setup-local-repo.sh" \
            --repo-dir "$LOCAL_REPO_DIR" \
            --repo-name "$LOCAL_REPO_DB" \
            --jobs "$PARALLEL_JOBS" \
            ${VERBOSE:+--verbose}
    else
        print_error "setup-local-repo.sh not found!"
        exit 1
    fi
    
    print_success "Local repository built at $LOCAL_REPO_DIR"
}

# Build the ISO using mkarchiso
build_iso() {
    if [[ "$BUILD_ISO" != true ]]; then
        print_info "Skipping ISO build"
        return 0
    fi
    
    print_step "Building RetroGameStation ISO..."
    
    local mkarchiso_args=(
        -v
        -w "$WORK_DIR"
        -o "$OUT_DIR"
        -j "$PARALLEL_JOBS"
    )
    
    if [[ "$SIGN_ISO" == true ]]; then
        if [[ -z "$GPG_KEY" ]]; then
            print_error "GPG key required for signing (--gpg-key)"
            exit 1
        fi
        mkarchiso_args+=(-g "$GPG_KEY")
    fi
    
    mkarchiso_args+=("$PROFILE_DIR")
    
    print_info "Running: mkarchiso ${mkarchiso_args[*]}"
    
    if [[ "$VERBOSE" == true ]]; then
        sudo mkarchiso "${mkarchiso_args[@]}"
    else
        sudo mkarchiso "${mkarchiso_args[@]}" 2>&1 | tail -20
    fi
    
    # Find the generated ISO
    local iso_file
    iso_file=$(find "$OUT_DIR" -name "*.iso" -type f | head -1)
    
    if [[ -n "$iso_file" ]]; then
        print_success "ISO built successfully: $iso_file"
        print_info "Size: $(du -h "$iso_file" | cut -f1)"
        
        # Generate checksums
        print_step "Generating checksums..."
        cd "$OUT_DIR"
        sha256sum "$(basename "$iso_file")" > "$(basename "$iso_file").sha256sum"
        print_success "Checksums generated"
    else
        print_error "ISO file not found in $OUT_DIR"
        exit 1
    fi
}

# Main function
main() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║              RetroGameStation ISO Builder                       ║
║       Hybrid Gaming (SteamOS) + Retroconsole Development        ║
╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    parse_args "$@"
    check_dependencies
    clean_directories
    build_local_repo
    build_iso
    
    print_success "Build completed successfully!"
    
    if [[ "$BUILD_ISO" == true ]]; then
        local iso_file
        iso_file=$(find "$OUT_DIR" -name "*.iso" -type f | head -1)
        echo ""
        print_info "Output ISO: $iso_file"
        print_info "To test in QEMU: qemu-system-x86_64 -enable-kvm -m 8G -cdrom \"$iso_file\""
        print_info "To write to USB: sudo dd if=\"$iso_file\" of=/dev/sdX bs=4M status=progress && sync"
    fi
}

# Run main
main "$@"