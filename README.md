# RetroGameStation - Archiso Profile

Distribuição Linux personalizada baseada no Arch Linux, focada em:
- **Gaming**: Estilo SteamOS com Gamescope + Steam
- **Retroconsole Development**: Toolchains para PS2, GameCube/Wii, GBA/NDS, 3DS, Switch, N64, Dreamcast, Saturn, PS1, PSP, Vita

## Estrutura do Projeto

```
archiso-profile/
├── profiledef.sh              # Definição do perfil archiso
├── pacman.conf                # Configuração do pacman com repos customizados
├── packages.x86_64            # Lista de pacotes oficiais
├── build.sh                   # Script de build da ISO
├── packages/
│   └── local/                 # Repositório local (gerado pelo setup-local-repo.sh)
├── scripts/
│   └── setup-local-repo.sh    # Script para construir repo local com pacotes AUR
├── airootfs/                  # Sistema de arquivos raiz da ISO
│   ├── etc/
│   │   ├── profile.d/
│   │   │   └── retrodev-env.sh    # Variáveis de ambiente para toolchains
│   │   ├── systemd/system/
│   │   │   ├── gamescope-session.service    # Serviço Gamescope/Steam
│   │   │   ├── steam-firstboot.service      # Setup inicial do Steam
│   │   │   └── retrodev-env-setup.service   # Setup toolchains
│   │   ├── sddm.conf.d/
│   │   │   └── autologin.conf               # Auto-login no Gamescope
│   │   ├── calamares/
│   │   │   └── settings.conf                # Config instalador
│   │   ├── mkinitcpio.d/
│   │   │   └── retrogamestation.preset      # Preset mkinitcpio
│   │   ├── pacman.d/
│   │   │   └── hooks/
│   │   │       └── retrogamestation-local-repo.hook
│   │   └── skel/                              # Arquivos do usuário
│   │       ├── .bashrc
│   │       ├── .profile
│   │       ├── .gitconfig
│   │       ├── .gitignore_global
│   │       └── .config/
│   │           └── starship.toml
│   ├── usr/
│   │   ├── local/bin/
│   │   │   ├── retrogame-setup       # Setup pós-instalação
│   │   │   ├── retrodev-env          # Carregar env retrodev
│   │   │   └── setup-local-repo      # Build repo local
│   │   └── share/
│   │       └── wayland-sessions/
│   │           └── gamescope-session.desktop
│   └── overlay/                      # Arquivos de overlay
└── work/                             # Diretório de trabalho (build)
└── out/                              # ISO de saída
```

## Toolchains Incluídos

| Plataforma | Toolchain | Localização |
|------------|-----------|-------------|
| PS2 | PS2SDK | `/opt/ps2sdk` |
| GameCube/Wii | devkitPPC | `/opt/devkitpro/devkitPPC` |
| GBA/NDS | devkitARM | `/opt/devkitpro/devkitARM` |
| 3DS | ctru/citro3d/citro2d | `/opt/devkitpro/ctru` |
| Switch | libnx | `/opt/libnx` |
| N64 | libdragon | `/opt/libdragon` |
| Dreamcast | KOS | `/opt/kos` |
| Saturn | Saturn SDK | `/opt/saturn-dev` |
| PS1 | PSYQ/PSn00bSDK | `/opt/psyq` |
| PSP | PSPSDK | `/opt/pspsdk` |
| Vita | VitaSDK | `/opt/vitasdk` |

## Build da ISO

### Pré-requisitos
```bash
sudo pacman -S archiso git base-devel
```

### Build completo
```bash
cd archiso-profile
chmod +x build.sh
sudo ./build.sh
```

### Opções do build.sh
```bash
./build.sh -h                    # Ajuda
./build.sh -c -C                 # Clean build
./build.sh --only-local-repo     # Apenas repo local
./build.sh --no-local-repo       # ISO sem repo local
./build.sh -s -k "Your Name"     # Build e assinar ISO
./build.sh -j 16                 # 16 jobs paralelos
```

## Repositório Local (Pacotes AUR/Retrodev)

O script `setup-local-repo.sh` baixa e compila pacotes do AUR:

```bash
# No sistema host (antes do build)
cd archiso-profile
chmod +x scripts/setup-local-repo.sh
./scripts/setup-local-repo.sh

# Ou apenas toolchains retrodev
./scripts/setup-local-repo.sh --only-retrodev

# Ou apenas pacotes específicos
./scripts/setup-local-repo.sh -p ps2sdk-git -p devkitarm-git
```

Os pacotes construídos ficam em `packages/local/` e são incluídos na ISO.

## Pós-Instalação

Após instalar no disco, execute:
```bash
sudo retrogame-setup
```

Isso configura:
- Serviços systemd
- Usuário `gamer` com auto-login
- Steam + Gamescope session
- Repositório local pacman
- Toolchains retrodev
- Locale pt_BR
- GRUB bootloader

## Uso das Toolchains

### Carregar ambiente específico
```bash
source retrodev-env ps2      # PS2
source retrodev-env ppc      # GameCube/Wii
source retrodev-env arm      # GBA/NDS
source retrodev-env nx       # Switch
source retrodev-env all      # Todas
```

### Criar projeto
```bash
new-retrodev-project meu-jogo ps2
new-retrodev-project meu-jogo nx
```

### Verificar toolchains
```bash
sysinfo
```

## Gaming

A ISO inicia direto no **Gamescope + Steam** (modo Big Picture/Steam Deck).

Para sair para desktop:
- `Super + Q` ou botão Steam → Exit → Return to Desktop

## Personalização

### Adicionar pacotes
Edite `packages.x86_64` e adicione os pacotes desejados.

### Modificar variáveis de ambiente
Edite `airootfs/etc/profile.d/retrodev-env.sh`

### Adicionar serviços systemd
Crie arquivos `.service` em `airootfs/etc/systemd/system/` e adicione ao `profiledef.sh`

### Mudar resolução Gamescope
Edite `airootfs/etc/systemd/system/gamescope-session.service`:
```bash
Environment=GAMESCOPE_RESOLUTION=3840x2160
Environment=GAMESCOPE_REFRESH=120
```

## Licença

MIT License - Veja LICENSE para detalhes.

## Links Úteis

- [Archiso Wiki](https://wiki.archlinux.org/title/archiso)
- [Gamescope](https://github.com/ValveSoftware/gamescope)
- [PS2SDK](https://github.com/ps2dev/ps2sdk)
- [devkitPro](https://devkitpro.org/)
- [libnx](https://github.com/devkitPro/libnx)
- [libdragon](https://github.com/DragonMinded/libdragon)