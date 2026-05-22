#!/usr/bin/env python3
"""theme skill -- generation engine.

Source of truth is ~/.config/theme/state.json: both slots (dark/light) hold a
16-colour base16 palette. Every per-tool theme file is a pure function of that
state and is fully regenerated on each run.

base16 is derived from a Ghostty theme's 16-colour ANSI palette: ~10 colours map
directly, the 6 in-between shades are interpolated.

Subcommands:
  init                 build state.json from Ghostty's current `theme =` line
                       (both slots seeded, neither marked nvim-themed), then
                       regenerate every file. Used by the one-time setup.
  apply --slot {dark,light} --theme-file PATH --name NAME
                       replace one slot from a Ghostty theme file, mark that
                       slot nvim-themed, regenerate every file.
  generate             regenerate every file from existing state.
  show                 print the current dark/light themes.

Generated files: ghostty/config (theme= line), nvim/lua/config/theme.lua,
bat/themes/theme-{dark,light}.tmTheme, fzf/theme-{dark,light}.zsh,
tmux/theme.conf. After generation `bat cache --build` is run.
"""

import argparse
import json
import os
import subprocess
import sys
import uuid

HOME = os.path.expanduser("~")
CONFIG = os.path.join(HOME, ".config")
STATE_DIR = os.path.join(CONFIG, "theme")
STATE_FILE = os.path.join(STATE_DIR, "state.json")

GHOSTTY_RESOURCES = "/Applications/Ghostty.app/Contents/Resources/ghostty/themes"
GHOSTTY_USER_THEMES = os.path.join(CONFIG, "ghostty", "themes")
GHOSTTY_CONFIG = os.path.join(CONFIG, "ghostty", "config")
NVIM_THEME_LUA = os.path.join(CONFIG, "nvim", "lua", "config", "theme.lua")
BAT_THEMES_DIR = os.path.join(CONFIG, "bat", "themes")
FZF_DIR = os.path.join(CONFIG, "fzf")
TMUX_THEME = os.path.join(CONFIG, "tmux", "theme.conf")

BASE16_KEYS = ["base0" + c for c in "0123456789ABCDEF"]
WRITTEN = []


# --------------------------------------------------------------------------
# colour utilities
# --------------------------------------------------------------------------
def parse_hex(h):
    h = h.strip().lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))


def to_hex(rgb):
    return "#{:02x}{:02x}{:02x}".format(*(max(0, min(255, round(c))) for c in rgb))


def mix(a, b, t):
    """Linear RGB interpolation. t=0 -> a, t=1 -> b."""
    ra, rb = parse_hex(a), parse_hex(b)
    return to_hex(tuple(ra[i] + (rb[i] - ra[i]) * t for i in range(3)))


# --------------------------------------------------------------------------
# Ghostty theme parsing + base16 derivation
# --------------------------------------------------------------------------
def parse_ghostty_theme(path):
    """Return ({ansi_index: hex}, {special_key: hex})."""
    palette, special = {}, {}
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, _, val = line.partition("=")
            key, val = key.strip(), val.strip()
            if key == "palette":
                idx, _, color = val.partition("=")
                try:
                    palette[int(idx.strip())] = color.strip()
                except ValueError:
                    pass
            else:
                special[key] = val
    return palette, special


def derive_base16(palette, special):
    """Derive 16 base16 colours from a Ghostty ANSI palette + bg/fg."""
    def a(n):
        return palette.get(n)

    bg = special.get("background") or a(0) or "#000000"
    fg = special.get("foreground") or a(7) or "#c0c0c0"

    base03 = a(8) or mix(bg, fg, 0.35)
    base07 = a(15) or fg
    base08 = a(1) or fg
    base0a = a(3) or fg
    base0b = a(2) or fg
    base0c = a(6) or fg
    base0d = a(4) or fg
    base0e = a(5) or fg

    b = {
        "base00": bg,
        "base05": fg,
        "base03": base03,
        "base07": base07,
        "base08": base08,
        "base0A": base0a,
        "base0B": base0b,
        "base0C": base0c,
        "base0D": base0d,
        "base0E": base0e,
    }
    # interpolated in-between shades
    b["base01"] = mix(bg, base03, 0.40)
    b["base02"] = mix(bg, base03, 0.75)
    b["base04"] = mix(base03, fg, 0.50)
    b["base06"] = mix(fg, base07, 0.50)
    b["base09"] = mix(base08, base0a, 0.50)
    b["base0F"] = mix(base0a, fg, 0.35)
    return {k: b[k] for k in BASE16_KEYS}


def resolve_ghostty_theme(name):
    """Find a Ghostty theme file by name (user dir first, then bundled)."""
    for d in (GHOSTTY_USER_THEMES, GHOSTTY_RESOURCES):
        p = os.path.join(d, name)
        if os.path.isfile(p):
            return p
    sys.exit("error: Ghostty theme not found: %r" % name)


def read_ghostty_theme_line():
    """Parse Ghostty's `theme =` line -> (dark_name, light_name)."""
    dark = light = None
    with open(GHOSTTY_CONFIG, encoding="utf-8") as f:
        for line in f:
            s = line.strip()
            if not s.startswith("theme") or "=" not in s:
                continue
            if s.split("=", 1)[0].strip() != "theme":
                continue
            val = s.split("=", 1)[1].strip()
            if "dark:" in val or "light:" in val:
                for part in val.split(","):
                    part = part.strip()
                    if part.startswith("dark:"):
                        dark = part[len("dark:"):].strip()
                    elif part.startswith("light:"):
                        light = part[len("light:"):].strip()
            else:
                dark = light = val
    if not dark or not light:
        sys.exit("error: could not parse `theme =` line in %s" % GHOSTTY_CONFIG)
    return dark, light


# --------------------------------------------------------------------------
# state
# --------------------------------------------------------------------------
def load_state():
    if not os.path.isfile(STATE_FILE):
        sys.exit("error: no theme state -- run the `theme` skill setup first.")
    with open(STATE_FILE, encoding="utf-8") as f:
        return json.load(f)


def save_state(state):
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f, indent=2)
        f.write("\n")


def slot_from_theme_file(name, path, nvim_themed):
    palette, special = parse_ghostty_theme(path)
    return {
        "name": name,
        "nvim_themed": nvim_themed,
        "base16": derive_base16(palette, special),
    }


# --------------------------------------------------------------------------
# file writing
# --------------------------------------------------------------------------
def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    WRITTEN.append(path)


HEADER = "Generated by the `theme` skill (theme.py). Do not edit by hand."


def lua_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def gen_nvim(state):
    def slot(s):
        b = s["base16"]
        items = "\n".join('      %s = "%s",' % (k, b[k]) for k in BASE16_KEYS)
        return (
            "{\n"
            "    name = %s,\n" % lua_str(s["name"])
            + "    themed = %s,\n" % ("true" if s["nvim_themed"] else "false")
            + "    base16 = {\n"
            + items
            + "\n    },\n  }"
        )

    out = (
        "-- %s\n" % HEADER
        + "return {\n"
        + "  dark = %s,\n" % slot(state["dark"])
        + "  light = %s,\n" % slot(state["light"])
        + "}\n"
    )
    write(NVIM_THEME_LUA, out)


TMTHEME = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>name</key><string>{name}</string>
  <key>settings</key>
  <array>
    <dict>
      <key>settings</key>
      <dict>
        <key>background</key><string>{base00}</string>
        <key>foreground</key><string>{base05}</string>
        <key>caret</key><string>{base05}</string>
        <key>invisibles</key><string>{base03}</string>
        <key>lineHighlight</key><string>{base01}</string>
        <key>selection</key><string>{base02}</string>
      </dict>
    </dict>
{scopes}
  </array>
  <key>uuid</key><string>{uuid}</string>
</dict>
</plist>
"""

# (textmate scope, base16 key)
SCOPE_MAP = [
    ("comment", "base03"),
    ("string", "base0B"),
    ("constant.numeric", "base09"),
    ("constant.language", "base09"),
    ("constant.character, constant.other", "base09"),
    ("variable", "base08"),
    ("keyword", "base0E"),
    ("storage", "base0E"),
    ("storage.type", "base0A"),
    ("entity.name.class, entity.name.type.class", "base0A"),
    ("entity.name.function, support.function", "base0D"),
    ("entity.name.tag", "base08"),
    ("entity.other.attribute-name", "base09"),
    ("support.type, support.class", "base0A"),
    ("support.constant", "base09"),
    ("punctuation", "base05"),
    ("invalid", "base08"),
    ("markup.inserted", "base0B"),
    ("markup.deleted", "base08"),
    ("markup.changed", "base0A"),
]


def gen_bat(state):
    for slot in ("dark", "light"):
        b = state[slot]["base16"]
        name = "theme-%s" % slot
        scopes = "\n".join(
            "    <dict>\n"
            "      <key>scope</key><string>%s</string>\n"
            "      <key>settings</key>\n"
            "      <dict><key>foreground</key><string>%s</string></dict>\n"
            "    </dict>" % (scope, b[key])
            for scope, key in SCOPE_MAP
        )
        xml = TMTHEME.format(
            name=name,
            base00=b["base00"], base05=b["base05"], base03=b["base03"],
            base01=b["base01"], base02=b["base02"],
            scopes=scopes,
            uuid=str(uuid.uuid5(uuid.NAMESPACE_DNS, "theme-skill-" + name)),
        )
        write(os.path.join(BAT_THEMES_DIR, "%s.tmTheme" % name), xml)


def gen_fzf(state):
    for slot in ("dark", "light"):
        b = state[slot]["base16"]
        # bg stays -1 (transparent -- inherits the terminal background)
        out = (
            "# %s\n" % HEADER
            + 'export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \\\n'
            + "--color=bg:-1,bg+:%s,fg:%s,fg+:%s \\\n"
            % (b["base01"], b["base04"], b["base06"])
            + "--color=hl:%s,hl+:%s,info:%s,spinner:%s \\\n"
            % (b["base0D"], b["base0D"], b["base0A"], b["base0C"])
            + "--color=prompt:%s,pointer:%s,marker:%s,header:%s \\\n"
            % (b["base0A"], b["base0C"], b["base0B"], b["base0D"])
            + '--color=border:%s,label:%s,selected-bg:%s"\n'
            % (b["base03"], b["base04"], b["base02"])
        )
        write(os.path.join(FZF_DIR, "theme-%s.zsh" % slot), out)


TMUX_TEMPLATE = """# {header}

if-shell "defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark" \\
    "set -g status-style bg=default,fg='{d05}'; \\
     set -g window-status-style bg=default,fg='{d05}'; \\
     set -g window-status-current-style bg=default,fg='{d08}'" \\
    "set -g status-style bg=default,fg='{l05}'; \\
     set -g window-status-style bg=default,fg='{l05}'; \\
     set -g window-status-current-style bg=default,fg='{l08}'"

if-shell "defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark" \\
    "set -g status-left '#[fg={d05},bg=default,bold] #{{?client_prefix,\U000f0820 ,#[dim]\U000f0902 }}#[bold,nodim]#S$hostname '; \\
     set -g status-right '#[bg=default,fg={d0A},noitalics,bold] %Y-%m-%d %H:%M '; \\
     set -g window-status-current-format '#[bg=default,fg={d09}] #W  '; \\
     set -g window-status-format '#[bg=default,fg={d05}] #W '" \\
    "set -g status-left '#[fg={l05},bg=default,bold] #{{?client_prefix,\U000f0820 ,#[dim]\U000f0902 }}#[bold,nodim]#S$hostname '; \\
     set -g status-right '#[bg=default,fg={l05},noitalics,bold] %Y-%m-%d %H:%M '; \\
     set -g window-status-current-format '#[bg=default,fg={l08}] #W   '; \\
     set -g window-status-format '#[bg=default,fg={l05}] #W '"
"""


def gen_tmux(state):
    d, l = state["dark"]["base16"], state["light"]["base16"]
    out = TMUX_TEMPLATE.format(
        header=HEADER,
        d05=d["base05"], d08=d["base08"], d09=d["base09"], d0A=d["base0A"],
        l05=l["base05"], l08=l["base08"],
    )
    write(TMUX_THEME, out)


def gen_ghostty(state):
    with open(GHOSTTY_CONFIG, encoding="utf-8") as f:
        lines = f.readlines()
    new = "theme = dark:%s,light:%s\n" % (
        state["dark"]["name"], state["light"]["name"])
    done = False
    for i, line in enumerate(lines):
        s = line.strip()
        if s.startswith("theme") and "=" in s and s.split("=", 1)[0].strip() == "theme":
            lines[i] = new
            done = True
            break
    if not done:
        if lines and not lines[-1].endswith("\n"):
            lines[-1] += "\n"
        lines.append(new)
    with open(GHOSTTY_CONFIG, "w", encoding="utf-8") as f:
        f.writelines(lines)
    WRITTEN.append(GHOSTTY_CONFIG)


def build_bat_cache():
    try:
        r = subprocess.run(["bat", "cache", "--build"],
                           capture_output=True, text=True)
        if r.returncode != 0:
            print("warning: `bat cache --build` failed: %s"
                  % r.stderr.strip(), file=sys.stderr)
    except FileNotFoundError:
        print("warning: `bat` not found; skipped cache build", file=sys.stderr)


def generate(state):
    gen_ghostty(state)
    gen_nvim(state)
    gen_bat(state)
    gen_fzf(state)
    gen_tmux(state)
    build_bat_cache()
    print("Wrote:")
    for p in WRITTEN:
        print("  " + p.replace(HOME, "~"))


# --------------------------------------------------------------------------
# commands
# --------------------------------------------------------------------------
def cmd_init(_args):
    dark_name, light_name = read_ghostty_theme_line()
    state = {
        "dark": slot_from_theme_file(
            dark_name, resolve_ghostty_theme(dark_name), False),
        "light": slot_from_theme_file(
            light_name, resolve_ghostty_theme(light_name), False),
    }
    save_state(state)
    generate(state)
    print("\nInitialised theme state: dark=%s light=%s" % (dark_name, light_name))


def cmd_apply(args):
    if args.slot not in ("dark", "light"):
        sys.exit("error: --slot must be 'dark' or 'light'")
    theme_file = os.path.expanduser(args.theme_file)
    if not os.path.isfile(theme_file):
        sys.exit("error: theme file not found: %s" % theme_file)
    state = load_state()
    state[args.slot] = slot_from_theme_file(args.name, theme_file, True)
    save_state(state)
    generate(state)
    print("\nApplied '%s' to the %s slot." % (args.name, args.slot))


def cmd_generate(_args):
    generate(load_state())


def cmd_show(_args):
    state = load_state()
    for slot in ("dark", "light"):
        s = state[slot]
        print("%-6s %s  (nvim_themed=%s)"
              % (slot + ":", s["name"], s["nvim_themed"]))


def main():
    ap = argparse.ArgumentParser(description="theme skill generation engine")
    sub = ap.add_subparsers(dest="cmd", required=True)

    sub.add_parser("init").set_defaults(func=cmd_init)
    sub.add_parser("generate").set_defaults(func=cmd_generate)
    sub.add_parser("show").set_defaults(func=cmd_show)

    ap_apply = sub.add_parser("apply")
    ap_apply.add_argument("--slot", required=True, choices=["dark", "light"])
    ap_apply.add_argument("--theme-file", required=True,
                          help="path to a Ghostty theme file")
    ap_apply.add_argument("--name", required=True,
                          help="theme name for the ghostty `theme =` line")
    ap_apply.set_defaults(func=cmd_apply)

    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
