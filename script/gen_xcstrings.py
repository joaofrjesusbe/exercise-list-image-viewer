#!/usr/bin/env python3
"""
Scan all L10n.swift files, extract LocalizedKey("...") definitions, and
write/merge a String Catalog (Localizable.xcstrings).

- Catalog key = Swift identifier (e.g., settingsAppearanceTitle)
- Development-language value = the literal inside LocalizedKey("...") (e.g., "Appearance")

Usage:
  python gen_xcstrings.py \
      --root . \
      --output ./Localization/Localizable.xcstrings \
      --source-language en \
      --langs en es pt
"""

import argparse
import json
import os
import re
import sys

# Matches: static let fooBar = LocalizedKey("Settings")
# Captures: identifier = fooBar, literal = "Settings"
DECL_RE = re.compile(
    r"""static\s+(?:let|var)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*LocalizedKey\(\s*"((?:[^"\\]|\\.)+)"\s*\)""",
    re.MULTILINE,
)

def find_l10n_swift_files(root):
    for dirpath, _, filenames in os.walk(root):
        for fn in filenames:
            if fn == "L10n.swift":  # adjust if you have multiple files names
                yield os.path.join(dirpath, fn)

def extract_keys(path):
    """
    Returns a list of (identifier, literal, filePath) from a L10n.swift file.
    """
    with open(path, "r", encoding="utf-8") as f:
        text = f.read()
    out = []
    for m in DECL_RE.finditer(text):
        ident = m.group(1)
        literal = m.group(2)
        out.append((ident, literal, path))
    return out

def load_existing_catalog(path):
    if not os.path.exists(path):
        return {"sourceLanguage": "en", "strings": {}, "version": "1.0"}
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def ensure_entry(catalog, key, dev_lang, dev_value, comment=None):
    """
    Ensure a string entry exists with key (identifier) and dev language value (literal).
    Does not overwrite existing values/translations.
    """
    strings = catalog.setdefault("strings", {})
    entry = strings.setdefault(key, {})
    if comment and "comment" not in entry:
        entry["comment"] = comment
    locs = entry.setdefault("localizations", {})
    lang_obj = locs.setdefault(dev_lang, {})
    unit = lang_obj.setdefault("stringUnit", {})
    if "value" not in unit or not unit.get("value"):
        unit["value"] = dev_value
        unit["state"] = "translated"
    else:
        unit.setdefault("state", "translated")
    return entry

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".", help="Project root to scan")
    ap.add_argument("--output", default="Localizable.xcstrings", help="Output .xcstrings path")
    ap.add_argument("--source-language", default="en", help="Development/source language code")
    ap.add_argument("--langs", nargs="*", default=["en"], help="Languages to ensure present")
    args = ap.parse_args()

    files = list(find_l10n_swift_files(args.root))
    if not files:
        print("No L10n.swift files found.", file=sys.stderr)
        return

    # Map identifier -> (literal, path) and detect conflicts
    found = {}
    conflicts = []
    for fp in files:
        for ident, literal, path in extract_keys(fp):
            if ident in found and found[ident][0] != literal:
                conflicts.append((ident, found[ident][0], literal, found[ident][1], path))
            else:
                found.setdefault(ident, (literal, path))

    for ident, old, new, p_old, p_new in conflicts:
        print(f"[warn] Identifier '{ident}' has conflicting literals:\n"
              f"  - '{old}' in {p_old}\n"
              f"  - '{new}' in {p_new}\n"
              f"  Using first occurrence ('{old}').", file=sys.stderr)

    catalog = load_existing_catalog(args.output)
    catalog["sourceLanguage"] = args.source_language
    catalog.setdefault("version", "1.0")
    catalog.setdefault("strings", {})

    # Write/merge entries
    for ident, (literal, path) in sorted(found.items(), key=lambda x: x[0].lower()):
        comment = f"{ident} (from {os.path.relpath(path, args.root)})"
        entry = ensure_entry(
            catalog,
            key=literal,                 # <-- key = Swift identifier
            dev_lang=args.source_language,
            dev_value=literal,         # <-- dev value = literal
            comment=comment
        )

        # Ensure placeholder entries for other languages
        locs = entry.setdefault("localizations", {})
        for lang in args.langs:
            locs.setdefault(lang, {})
            if lang == args.source_language:
                continue
            unit = locs[lang].setdefault("stringUnit", {})
            # Don't overwrite translations
            unit.setdefault("value", "")
            unit.setdefault("state", "needs-translation")

    # Save
    os.makedirs(os.path.dirname(args.output) or ".", exist_ok=True)
    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(catalog, f, ensure_ascii=False, indent=2)

    print(f"Wrote {args.output} with {len(found)} keys from {len(files)} file(s).")

if __name__ == "__main__":
    main()
