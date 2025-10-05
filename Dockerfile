# Base image with Python (slim = smaller size)
FROM python:3.12-slim

# Install fonttools
RUN pip install --no-cache-dir fonttools

# Set working directory
WORKDIR /app


# Copy your font files and scripts into the container
COPY . .

# Ensure output/fonts directory exists
RUN mkdir -p /app/output/fonts

# Make sure the script is executable
RUN chmod +x generate_fonts.sh
RUN chmod +x generate_material_symbol_icon_names.sh

# Run both scripts in parallel, outputting fonts to /output/fonts and icon names to /output/material-symbol-icon-names.ts
CMD ["bash", "-c", "./generate_fonts.sh & ./generate_material_symbol_icon_names.sh & wait"]
