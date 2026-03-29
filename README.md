# ⌨️ Tamazight Keyboard Layout for Linux

A one-script installer that adds a **Tamazight (QWERTY - Latin - Tamamerit) keyboard layout** to GNOME on Linux — no manual XKB editing, no reboot required.

Built for Fedora 49 and tested on Wayland. Should work on any GNOME-based distro that uses `gsettings` for input source management.

---

## What It Does

The layout follows a **QWERTY base** and adds Tamazight-specific characters where they naturally belong, using the **Shift** layer for uppercase and dedicated keys for phonemes that don't exist in standard Latin.

### Key Mapping

| Key | Unshifted | Shifted | Notes               |
| --- | --------- | ------- | ------------------- |
| `r` | `r`       | `R`     | AltGr: `ṛ` / `Ṛ`    |
| `t` | `t`       | `T`     | AltGr: `ṭ` / `Ṭ`    |
| `s` | `s`       | `S`     | AltGr: `ṣ` / `Ṣ`    |
| `d` | `d`       | `D`     | AltGr: `ḍ` / `Ḍ`    |
| `g` | `g`       | `G`     | AltGr: `ǧ` / `Ǧ`    |
| `z` | `z`       | `Z`     | AltGr: `ẓ` / `Ẓ`    |
| `c` | `c`       | `C`     | AltGr: `č` / `Č`    |
| `o` | `ɛ`       | `Ɛ`     | -                   |
| `p` | `ḥ`       | `Ḥ`     | -                   |
| `v` | `ɣ`       | `Ɣ`     | -                   |
| `4` | `4`       | `ⵣ`     | Tifinagh Z (U+2D63) |
| `,` | `,`       | `«`     | French guillemet    |
| `.` | `.`       | `»`     | French guillemet    |
![[1.png]]![[2.png]]![[3.png]]
![[4.png]]
_Visual reference for the key mapping._

---

## Requirements

- Linux with **GNOME** desktop environment
- `gsettings` (ships with GNOME)
- `python3` (used internally to safely parse gsettings values)
- Bash 4+

Tested on **Fedora 49** (Wayland). Should work on Ubuntu/Debian GNOME, openSUSE, Arch+GNOME, and similar.

---

## Installation

```bash
# Clone or download the script
git clone https://github.com/m4sensen/tamazight-tamamerit-keyboard.git
cd tamazight-tamamerit-keyboard

bash main.sh install
```

The script will:

1. Write the XKB symbols file to `~/.config/xkb/symbols/ber`
2. Write the rules file to `~/.config/xkb/rules/evdev.xml`
3. Add the layout to GNOME's input sources via `gsettings`

No `sudo` needed. Everything installs to your home directory.

![#2](#)
_Illustration of the installation process._

---

## Switching to the Layout

After installation, switch layouts with:

```
Super + Space
```

Or open **Settings → Keyboard → Input Sources** to manage layouts visually.

The layout appears as **"Tamazight (QWERTY, Latin, Tamamerit)"** in the GNOME input source selector.

![[6.png]]
_Screenshot showing the layout in GNOME input sources._

---

## Uninstallation

```bash
bash main.sh uninstall
```

This removes both the XKB files and the entry from GNOME's input sources. Your other layouts remain untouched.

---

## How It Works

GNOME supports **user-local XKB configuration** at `~/.config/xkb/` — no system-wide files are touched. The script places two files:

```
~/.config/xkb/
├── symbols/
│   └── ber          ← XKB symbols definition (the actual key mappings)
└── rules/
    └── evdev.xml    ← Layout metadata (name, language tag, variant list)
```

The layout is then registered in GNOME's input sources using `gsettings`, which handles both Wayland (libxkbcommon reads `~/.config/xkb` natively) and X11 (GNOME applies it via setxkbmap on session start).

`gsettings` values are parsed with `python3 -c "import ast, os; ..."` using environment variables to safely handle shell quoting — no `eval`, no injection risk.

---

## Layout Design Decisions

- **QWERTY base** — familiar to anyone typing Latin-script languages, minimal relearning curve.
- **Phoneme-first placement** — emphatic consonants (`ṣ ḍ ṭ ṛ ẓ`) are on AltGr of their plain equivalents, so muscle memory transfers.
- **Epsilon (`ɛ`) on `o` and Gamma (`ɣ`) on `v`** — these are positionally unintuitive but chosen to avoid displacing common Latin characters.
- **Tifinagh Z (`ⵣ`) on Shift+4** — a nod to the symbol's cultural significance; easily accessible without displacing number-row logic.
- **`«` and `»` on Shift+`,`/`Shift+.`** — Tamazight publishing often follows French typographic conventions.

---

## File Reference

| File                            | Location     | Purpose                       |
| ------------------------------- | ------------ | ----------------------------- |
| `main.sh`                       | Project root | Main install/uninstall script |
| `~/.config/xkb/symbols/tmz`     | User XKB dir | Key mapping definitions       |
| `~/.config/xkb/rules/evdev.xml` | User XKB dir | Layout registration metadata  |

---

## Troubleshooting

**Layout doesn't appear in GNOME Settings**
Log out and back in. GNOME caches input sources on session start.

**Characters don't type correctly on Wayland**
Ensure your compositor reads `~/.config/xkb`. This is standard in GNOME 42+ but may require a session restart after first install.

**AltGr characters don't work**
The layout uses `include "level3(ralt_switch)"` which maps Right Alt to the Level 3 modifier. If your keyboard remaps Right Alt, this won't work without adjusting the symbols file.

**Script fails on non-GNOME desktops**
This script is GNOME-specific. For KDE, XFCE, or bare X11 setups, the XKB files can still be used — but you'll need to apply them manually (e.g. via `setxkbmap`).

---

## Contributing

Issues, corrections to the key mappings, and compatibility reports from other distros are all welcome. Open an issue or submit a pull request.

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

_Made with love for Tamazight. ❤️ⵣ_

```

```
