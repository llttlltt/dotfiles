#!/usr/bin/env python3
import sys
from pathlib import Path
from plistlib import load as load_plist
from typing import Dict, Iterator, Tuple

BLUE = "Blue Component"
GREEN = "Green Component"
RED = "Red Component"

def dict_from_plist_file(plistfile: Path) -> Dict:
    with open(plistfile, 'rb') as pf:
        return load_plist(pf)

def rgb_to_hex(r: int, g: int, b: int) -> str:
    return f"#{r:02X}{g:02X}{b:02X}"

def component_to_int(c: str) -> int:
    return int(float(c) * 255.0)

def key_color_pairs(plistfile: Path) -> Iterator[Tuple[str, str]]:
    for key, components in dict_from_plist_file(plistfile).items():
        r = component_to_int(components[RED])
        g = component_to_int(components[GREEN])
        b = component_to_int(components[BLUE])
        yield (key, rgb_to_hex(r, g, b))

def main(plistfile: Path):
    color_map = {key: color for key, color in key_color_pairs(plistfile)}

    config_lines = []
    ansi_color_keys = [f"Ansi {i} Color" for i in range(16)]

    for i, comment_key in enumerate(ansi_color_keys):
        if comment_key in color_map:
            config_lines.append(f"palette = {i}={color_map[comment_key]}")

    if 'Background Color' in color_map:
        config_lines.append(f"background = {color_map['Background Color']}")
    
    if 'Foreground Color' in color_map:
        config_lines.append(f"foreground = {color_map['Foreground Color']}")
    
    if 'Cursor Color' in color_map:
        config_lines.append(f"cursor-color = {color_map['Cursor Color']}")
    
    if 'Cursor Text Color' in color_map:
        config_lines.append(f"cursor-text = {color_map['Cursor Text Color']}")
    
    if 'Selection Color' in color_map:
        config_lines.append(f"selection-background = {color_map['Selection Color']}")
    
    if 'Selected Text Color' in color_map:
        config_lines.append(f"selection-foreground = {color_map['Selected Text Color']}")

    config_output = '\n'.join(config_lines)
    output_file = Path(plistfile).with_suffix('.conf').with_name(Path(plistfile).stem)
    
    with open(output_file, "w") as config_file:
        config_file.write(config_output)

    print(f"Configuration file '{output_file}' created successfully.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 iTermColorsToGhosttyTheme.py <plistfile>")
        sys.exit(1)

    plistfile = Path(sys.argv[1])
    main(plistfile)
