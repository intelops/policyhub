#!/bin/bash

# Function to read version from a specified version file
read_version() {
  local version_file=$1
  if [ -f "$version_file" ]; then
    # Extract the version value from the file
    local version_value=$(grep -oP '=(.*)$' "$version_file" | cut -d'=' -f2)
    echo "$version_value"
  else
    echo "Version file not found: $version_file"
    exit 1
  fi
}

# Check the input parameter
if [ -z "$1" ]; then
  echo "Usage: $0 <version_file>"
  exit 1
fi

# Call the function with the specified version file
read_version "$1"
