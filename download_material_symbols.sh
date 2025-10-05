#!/bin/bash
set -e

# Download Material Symbols variable fonts from marella's repo (Google does not provide direct raw links)
base_url="https://github.com/marella/material-symbols/raw/main/variablefont"
fonts=(
  "MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"
  "MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf"
  "MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf"
)

mkdir -p input
for font in "${fonts[@]}"; do
  encoded_font="${font//[/\%5B}"
  encoded_font="${encoded_font//]/\%5D}"
  echo "Downloading $font..."
  curl -L "$base_url/$encoded_font" -o "input/$font"
done

# Download a .codepoints file (Outlined variant as example)
codepoints_file="MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].codepoints"
encoded_codepoints="${codepoints_file//[/\%5B}"
encoded_codepoints="${encoded_codepoints//]/\%5D}"
echo "Downloading $codepoints_file..."
curl -L "$base_url/$encoded_codepoints" -o "input/$codepoints_file"

echo "✅ All files downloaded to ./input"
