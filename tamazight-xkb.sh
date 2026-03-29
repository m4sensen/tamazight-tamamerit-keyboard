#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  Tamazight Keyboard Layout Manager
#  Layout : Tamazight (QWERTY, Latin, Tamamerit)
#  Fixed Safe Version for Fedora 49 / GNOME (Wayland & X11)
# ══════════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────
R='\033[0;31m'  Y='\033[0;33m'  G='\033[0;32m'
C='\033[0;36m'  B='\033[1;34m'  W='\033[1;37m'  N='\033[0m'

# ── Config ───────────────────────────────────────────────────────────
LAYOUT_NAME="ber"
VARIANT_NAME="custom"
# Note: In GNOME, the source is usually 'layout+variant'
FULL_LAYOUT_ID="${LAYOUT_NAME}+${VARIANT_NAME}"

XKB_DIR="$HOME/.config/xkb"
SYMBOLS_FILE="$XKB_DIR/symbols/ber"
RULES_FILE="$XKB_DIR/rules/evdev.xml"
GSETTINGS_KEY="org.gnome.desktop.input-sources"
GSETTINGS_FIELD="sources"

# ── XKB symbols content ──────────────────────────────────────────────
read -r -d '' SYMBOLS_CONTENT << 'EOF' || true
default partial alphanumeric_keys
xkb_symbols "custom" {

    name[Group1] = "Tamazight (QWERTY, Latin, Tamɛemrit)";

    // Include standard definitions so Shift/Control work normally
    include "pc"
    include "latin"

    // Number row
    key <TLDE> { [ grave, asciitilde ] };
    key <AE01> { [ 1, exclam ] };
    key <AE02> { [ 2, at ] };
    key <AE03> { [ 3, numbersign ] };
    key <AE04> { [ 4, U2D63 ] };
    key <AE05> { [ 5, percent ] };
    key <AE06> { [ 6, asciicircum ] };
    key <AE07> { [ 7, ampersand ] };
    key <AE08> { [ 8, asterisk ] };
    key <AE09> { [ 9, parenleft ] };
    key <AE10> { [ 0, parenright ] };
    key <AE11> { [ minus, underscore ] }; 
    key <AE12> { [ equal, plus ] };

    // Top row
    key <AD01> { [ q, Q ] };
    key <AD02> { [ w, W ] };
    key <AD03> { [ e, E ] };

    key <AD04> { type="FOUR_LEVEL", [ r, R, U1E5B, U1E5A ] }; // r R ṛ Ṛ
    key <AD05> { type="FOUR_LEVEL", [ t, T, U1E6D, U1E6C ] }; // t T ṭ Ṭ
    
    key <AD06> { [ y, Y ] };
    key <AD07> { [ u, U ] };
    key <AD08> { [ i, I ] };

    key <AD09> { [ U025B, U0190 ] }; // ɛ Ɛ
    key <AD10> { [ U1E25, U1E24 ] }; // ḥ Ḥ (Added missing semicolon)

    // Home row
    key <AC01> { [ a, A ] };
    key <AC02> { type="FOUR_LEVEL", [ s, S, U1E63, U1E62 ] }; // s S ṣ Ṣ
    key <AC03> { type="FOUR_LEVEL", [ d, D, U1E0D, U1E0C ] }; // d D ḍ Ḍ
    key <AC04> { [ f, F ] };
    key <AC05> { type="FOUR_LEVEL", [ g, G, U01E7, U01E6 ] }; // g G ǧ Ǧ
    key <AC06> { [ h, H ] }; // Removed redundant FOUR_LEVEL type
    
    key <AC07> { [ j, J ] };
    key <AC08> { [ k, K ] };
    key <AC09> { [ l, L ] };

    // Bottom row
    key <AB01> { type="FOUR_LEVEL", [ z, Z, U1E93, U1E92 ] }; // z Z ẓ Ẓ
    key <AB02> { [ x, X ] };
    key <AB03> { type="FOUR_LEVEL", [ c, C, U010D, U010C ] }; // c C č Č
    key <AB04> { [ U0263, U0194 ] }; // ɣ Ɣ

    key <AB05> { [ b, B ] };
    key <AB06> { [ n, N ] };
    key <AB07> { [ m, M ] };
    key <AB08> { [ comma,  U00AB ] }; // , «
    key <AB09> { [ period, U00BB ] }; // . »

    // Modifiers: Using Right Alt (AltGr) for special characters
    include "level3(ralt_switch)"
};
EOF

# ── evdev.xml content ────────────────────────────────────────────────
read -r -d '' RULES_CONTENT << 'EOF' || true
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xkbConfigRegistry SYSTEM "xkb.dtd">
<xkbConfigRegistry version="1.1">
  <layoutList>
    <layout>
      <configItem>
        <name>ber</name>
        <shortDescription>TMZ</shortDescription>
        <description>Tamazight (QWERTY, Latin, Tamɛemrit)</description>
        <languageList><iso639Id>ber</iso639Id></languageList>
      </configItem>
      <variantList>
        <variant>
          <configItem>
            <name>custom</name>
            <description>Tamazight (Custom)</description>
          </configItem>
        </variant>
      </variantList>
    </layout>
  </layoutList>
</xkbConfigRegistry>
EOF

# ════════════════════════════════════════════════════════════════════
ok()   { echo -e "  ${G}✔${N}  $*"; }
warn() { echo -e "  ${Y}⚠${N}  $*"; }
err()  { echo -e "  ${R}✘${N}  $*"; }
info() { echo -e "  ${C}→${N}  $*"; }
sep()  { echo -e "  ${B}────────────────────────────────────────${N}"; }

# Safely check if layout exists using Env Var to avoid quote issues
gsettings_has_layout() {
    local current
    current=$(gsettings get "$GSETTINGS_KEY" "$GSETTINGS_FIELD")
    export CURRENT_SOURCES="$current"
    export TARGET_LAYOUT="$FULL_LAYOUT_ID"
    python3 -c "import ast, os; s=ast.literal_eval(os.environ['CURRENT_SOURCES']); print(any(t[1]==os.environ['TARGET_LAYOUT'] for t in s))" | grep -q True
}

cmd_install() {
    echo -e "\n${W}  Installing Tamazight layout…${N}"
    sep

    mkdir -p "$XKB_DIR/symbols" "$XKB_DIR/rules"
    echo "$SYMBOLS_CONTENT" > "$SYMBOLS_FILE"
    echo "$RULES_CONTENT" > "$RULES_FILE"
    ok "Files written to $XKB_DIR"

    if gsettings_has_layout; then
        warn "Layout already in GNOME sources."
    else
        current=$(gsettings get "$GSETTINGS_KEY" "$GSETTINGS_FIELD")
        export CURRENT_SOURCES="$current"
        export TARGET_LAYOUT="$FULL_LAYOUT_ID"
        
        new_sources=$(python3 -c "import ast, os; s=ast.literal_eval(os.environ['CURRENT_SOURCES']); s.append(('xkb', os.environ['TARGET_LAYOUT'])); print(s)")
        
        if [[ -n "$new_sources" ]]; then
            gsettings set "$GSETTINGS_KEY" "$GSETTINGS_FIELD" "$new_sources"
            ok "Added to GNOME input sources."
        else
            err "Failed to update GNOME sources."
        fi
    fi

    ok "Installation complete!"
    info "Use Super+Space to switch."
}

cmd_uninstall() {
    echo -e "\n${W}  Uninstalling Tamazight layout…${N}"
    sep

    if gsettings_has_layout; then
        current=$(gsettings get "$GSETTINGS_KEY" "$GSETTINGS_FIELD")
        export CURRENT_SOURCES="$current"
        export TARGET_LAYOUT="$FULL_LAYOUT_ID"
        
        new_sources=$(python3 -c "import ast, os; s=ast.literal_eval(os.environ['CURRENT_SOURCES']); s=[t for t in s if t[1] != os.environ['TARGET_LAYOUT']]; print(s)")
        gsettings set "$GSETTINGS_KEY" "$GSETTINGS_FIELD" "$new_sources"
        ok "Removed from GNOME sources."
    fi

    rm -f "$SYMBOLS_FILE" "$RULES_FILE"
    ok "Files removed."
}

case "${1:-help}" in
    install) cmd_install ;;
    uninstall) cmd_uninstall ;;
    *) echo "Usage: $0 {install|uninstall}" ;;
esac
