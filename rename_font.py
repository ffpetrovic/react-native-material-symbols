#!/usr/bin/env python3
"""
Simple script to rename font files using fonttools.
This script takes an input font file, an output font file, and a new font name.
"""
import sys
from fontTools.ttLib import TTFont

def rename_font(input_file, output_file, new_name):
    """Rename a font's internal name and save it to a new file."""
    try:
        # Load the font
        font = TTFont(input_file)
        
        # Update the font name in the 'name' table
        if 'name' in font:
            name_table = font['name']
            
            # Update family name (nameID 1)
            for record in name_table.names:
                if record.nameID == 1:  # Font Family name
                    record.string = new_name.encode('utf-16-be') if record.platformID == 3 else new_name.encode('utf-8')
                elif record.nameID == 4:  # Full font name
                    record.string = new_name.encode('utf-16-be') if record.platformID == 3 else new_name.encode('utf-8')
                elif record.nameID == 6:  # PostScript name
                    record.string = new_name.replace(' ', '').encode('utf-16-be') if record.platformID == 3 else new_name.replace(' ', '').encode('utf-8')
        
        # Save the modified font
        font.save(output_file)
        font.close()
        
        print(f"✅ Successfully renamed font to: {new_name}")
        
    except Exception as e:
        print(f"❌ Error processing font {input_file}: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python3 rename_font.py <input_file> <output_file> <new_name>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    new_name = sys.argv[3]
    
    rename_font(input_file, output_file, new_name)