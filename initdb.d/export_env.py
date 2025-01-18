#!/usr/bin/env python3
import sys
import os

def export_env_from_file(file_path):
    try:
        with open(file_path, "r") as f:
            for line in f:
                # Strip whitespace and ignore comments or empty lines
                line = line.strip()
                if not line or line.startswith("#"):
                    continue

                # Split the line into key and value
                if "=" in line:
                    key, value = line.split("=", 1)
                    key = key.strip()
                    value = value.strip()

                    # Validate key
                    if not key.isidentifier():
                        print(f"Skipping invalid key: {key}", file=sys.stderr)
                        continue

                    # Print export statement
                    print(f'export {key}="{value}"')
    except FileNotFoundError:
        print(f"Error: File {file_path} not found.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <env_file>", file=sys.stderr)
        sys.exit(1)

    export_env_from_file(sys.argv[1])
