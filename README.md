# RetroGameStation OS

Distribuição Linux personalizada baseada no Arch Linux, focada em:
- **Gaming Híbrido**: Estilo SteamOS com Gamescope + Steam Big Picture + KDE Plasma Desktop
- **Retroconsole Development**: Toolchains para PS2, GameCube/Wii, GBA/NDS, 3DS, Switch, N64, Dreamcast, Saturn, PS1, PSP, Vita
- **Reverse Engineering**: Ghidra, Radare2/Cutter, Binwalk, Pwntools, Ropper, Checksec, Frida

---

## 📦 Status do Build

| Item | Status |
|------|--------|
| **Última ISO** | `retrogamestation-2026.11.12-x86_64.iso` (~7.8 GB) |
| **Commit** | [`166b103`](https://github.com/Luizfe181/RetroGameStation-OS/commit/166b103) |
| **Build CI** | ✅ GitHub Actions (passing) |
| **Release** | [v2024.12](https://github.com/Luizfe181/RetroGameStation-OS/releases/tag/v2024.12) |
| **SHA256** | `5ae31d697dcc01b090d20b6882fd8a228b1c0443b32e52c12e7abbe0e2d72cc5` |

---

## 🎯 Features Principais

### 🎮 Gaming (SteamOS Style)
- **Gamescope** + **Steam Big Picture** (auto-login, modo console)
- **KDE Plasma Desktop** (troca instantânea via `Super+Q` ou `F1`)
- **MangoHUD** + **GOverlay** + **vkBasalt** (overlay performance, FSR/CAS)
- **PipeWire** + **WirePlumber** (áudio low-latency)
- Drivers AMD/Intel/NVIDIA (NVIDIA comentado por padrão)
- Suporte a controles (Steam Input, hidapi, SDL2)

### 🛠 Retroconsole Development Toolchains
| Plataforma | Toolchain | Status |
|------------|-----------|--------|
| **ARM** (GBA, NDS, 3DS, Switch, PSP, Vita, PS2) | `arm-none-eabi-gcc/binutils/newlib` (extra) | ✅ ISO |
| **MIPS** (PS2, N64, PSP) | via `devkitpro-pacman` (AUR) | Pós-install |
| **PowerPC** (GameCube/Wii) | via `devkitpro-pacman` | Pós-install |
| **SuperH** (Saturn, Dreamcast) | via `devkitpro-pacman` | Pós-install |
| **RISC-V** (homebrew futuro) | via `devkitpro-pacman` | Pós-install |

> **Nota:** Toolchains MIPS/PPC/SH/RISC-V são instalados via `retrogame-setup` → `devkitpro-pacman` (AUR) para evitar conflitos.

### 🔍 Reverse Engineering
| Ferramenta | Status |
|------------|--------|
| Ghidra, Radare2/Cutter, Binwalk | ✅ ISO (extra) |
| Pwntools, Ropper, ROPgadget, Checksec | ✅ ISO (extra) |
| Frida, python-frida, python-pwntools | Pós-install (AUR/pipx) |
| python-ropgadget, python-checksec | Pós-install (AUR/pipx) |

### 🎮 Emuladores (Oficiais - extra)
| Console | Emulador |
|---------|----------|
| PS2 | PCSX2 |
| PS3 | RPCS3 |
| GameCube/Wii | Dolphin |
| Switch | Citra (via Ryujinx-git no local repo) |
| PS1/PSP | DuckStation, PPSSPP |
| N64 | Mupen64Plus, Parallel-N64, Ares |
| Dreamcast | Flycast (libretro) |
| Saturn | Kronos, Beetle Saturn (libretro) |
| Multi | RetroArch + cores libretro |

### 🎨 Branding Customizado
| Componente | Tema |
|------------|------|
| **GRUB** | Dark/Retro-futurista (preto #000000, neon cyan #00A8FF) |
| **Plymouth** | Splash + vídeo com áudio (ffplay) |
| **Calamares** | Dark sidebar (#0A0E17), neon accents, 3 slides |
| **Slideshow** | 1) Gaming Híbrido 2) Laboratório Retrodev 3) Atalhos (Super+Q/F1) |

---

## 📁 Estrutura do Projeto

```
archiso-profile/
├── profiledef.sh              # Perfil archiso (metadados, bootmodes, services)
├── pacman.conf                # Repos: core/extra/multilib + local repo
├── packages.x86_64            # ~380 pacotes oficiais (core/extra/multilib)
├── build.sh                   # Script de build (clean, jobs, sign, etc)
├── packages/
│   └── local/                 # Repo local AUR (gerado no CI)
├── scripts/
│   └── setup-local-repo.sh    # Builda goverlay, vkbasalt, ryujinx-git
├── airootfs/                  # Rootfs da ISO
│   ├── boot/grub/themes/retrogamestation/theme.txt
│   ├── etc/
│   │   ├── calamares/branding/retrogamestation/
│   │   ├── systemd/system/ (gamescope-session, steam-firstboot, boot-video)
│   │   ├── profile.d/retrodev-env.sh
│   │   ├── sddm.conf.d/autologin.conf
│   │   └── calamares/settings.conf (dual boot, os-prober)
│   ├── usr/
│   │   ├── local/bin/ (retrogame-setup, retrodev-env, session-switch, retrodev-clone, play-boot-video-ffplay)
│   │   └── share/plymouth/themes/retrogamestation/
│   └── usr/share/retrogamestation/boot-video.mp4
├── syslinux/syslinux.cfg      # BIOS boot menu
├── efiboot/loader/entries/    # systemd-boot UEFI entries
└── .github/workflows/build-iso.yml  # CI/CD
```

---

## 🚀 Build da ISO

### Pré-requisitos
```bash
sudo pacman -S archiso git base-devel
```

### Build Local
```bash
cd archiso-profile
chmod +x build.sh

# Build completo (repo local + ISO)
sudo ./build.sh

# Apenas repo local (AUR)
sudo ./build.sh --only-local-repo

# ISO sem rebuildar repo local
sudo ./build.sh --no-local-repo

# Clean build
sudo ./build.sh -c -C

# Assinar ISO
sudo ./build.sh -s -k "Your Name"
```

### CI/CD (GitHub Actions)
```yaml
# Trigger automático: push para main ou tag v*
# Builda repo local (goverlay, vkbasalt, ryujinx-git)
# Copia para /var/cache/pacman/retrogamestation-local
# Builda ISO via mkarchiso
# Upload artifact + Release automático em tags v*
```

---

## 📥 Pós-Instalação

Após instalar no disco (Calamares):

```bash
# 1. Setup completo (services, user, steam, locale, grub, repo local)
sudo retrogame-setup

# 2. Instalar toolchains retrodev (devkitPro, PS2SDK, libdragon, VitaSDK, libnx, KOS, etc)
retrogame-setup toolchains

# 3. Instalar emuladores git / RE tools extras
retrogame-setup aur

# 4. Carregar ambiente retrodev
source retrodev-env ps2      # PS2
source retrodev-env ppc      # GameCube/Wii
source retrodev-env arm      # GBA/NDS/3DS/Switch/PSP/Vita
source retrodev-env nx       # Switch (libnx)
source retrodev-env all      # Todas

# 5. Criar projeto
new-retrodev-project meu-jogo ps2
new-retrodev-project meu-jogo nx
```

---

## ⌨️ Atalhos do Sistema

| Ação | Tecla/Comando |
|------|---------------|
| **Alternar Console ↔ Desktop** | `Super + Q` ou `F1` |
| **Sair Gamescope → Desktop** | Botão Steam → Exit → Return to Desktop |
| **Trocar sessão** | `session-switch {console\|desktop\|hybrid}` |
| **Clonar repo retrodev** | `retrodev-clone ps2sdk` |
| **Carregar env** | `source retrodev-env ps2` |
| **Criar projeto** | `new-retrodev-project meu-jogo ps2` |
| **Info sistema** | `sysinfo` |

---

## 🔧 Personalização

### Adicionar Pacotes
Edite `packages.x86_64` (apenas pacotes de core/extra/multilib).

### Adicionar Pacotes AUR
Adicione em `scripts/setup-local-repo.sh` na lista `ESSENTIAL_PACKAGES`.

### Variáveis de Ambiente Retrodev
Edite `airootfs/etc/profile.d/retrodev-env.sh`

### Resolução Gamescope
```bash
# Editar airootfs/etc/systemd/system/gamescope-session.service
Environment=GAMESCOPE_RESOLUTION=3840x2160
Environment=GAMESCOPE_REFRESH=120
```

### Boot Video
Substitua `airootfs/usr/share/retrogamestation/boot-video.mp4` (H.264, 1080p, com áudio).

---

## 🔄 Dual Boot Windows

O Calamares já detecta Windows via `os-prober`:
1. Inicie o instalador (ícone "Install RetroGameStation")
2. Escolha **"Instalar junto com Windows"**
3. GRUB configurado automaticamente com entrada Windows

---

## 📥 Download

| Versão | Link | SHA256 |
|--------|------|--------|
| **v2024.12** | [Release](https://github.com/Luizfe181/RetroGameStation-OS/releases/tag/v2024.12) | `5ae31d697dcc01b090d20b6882fd8a228b1c0443b32e52c12e7abbe0e2d72cc5` |
| **Latest CI** | [Actions Artifacts](https://github.com/Luizfe181/RetroGameStation-OS/actions) | Ver run |

---

## 🧪 Testar a ISO

```bash
# QEMU (UEFI) - Recomendado
qemu-system-x86_64 -enable-kvm -m 8G -cpu host -smp 4 \
  -bios /usr/share/edk2-ovmf/x64/OVMF.fd \
  -cdrom retrogamestation-2026.11.12-x86_64.iso \
  -boot d -vga virtio -display sdl,gl=on

# VirtualBox: Enable EFI + 3D Acceleration + 8GB RAM
# VMware: Enable EFI + 3D + 8GB RAM
```

### Checklist de Teste
- [ ] GRUB menu com tema customizado
- [ ] Plymouth splash → vídeo com áudio
- [ ] Auto-login Gamescope + Steam Big Picture
- [ ] `Super+Q` / `F1` troca para KDE Plasma
- [ ] Calamares abre com tema dark + 3 slides
- [ ] Detecção Windows no particionamento
- [ ] Emuladores abrem (PCSX2, RPCS3, Dolphin, Citra, DuckStation)
- [ ] RE Tools: Ghidra, Radare2/Cutter, Binwalk

---

## 📄 Licença

MIT License - Veja [LICENSE](LICENSE) para detalhes.

---

## 🔗 Links Úteis

- [GitHub Repo](https://github.com/Luizfe181/RetroGameStation-OS)
- [Releases](https://github.com/Luizfe181/RetroGameStation-OS/releases)
- [CI/CD Actions](https://github.com/Luizfe181/RetroGameStation-OS/actions)
- [Archiso Wiki](https://wiki.archlinux.org/title/archiso)
- [Gamescope](https://github.com/ValveSoftware/gamescope)
- [PS2SDK](https://github.com/ps2dev/ps2sdk)
- [devkitPro](https://devkitpro.org/)
- [libnx](https://github.com/devkitPro/libnx)
- [libdragon](https://github.com/DragonMinded/libdragon)
- [devkitPro-pacman (AUR)](https://aur.archlinux.org/packages/devkitpro-pacman)

---

*RetroGameStation OS - Hybrid Gaming & Retroconsole Development Station*