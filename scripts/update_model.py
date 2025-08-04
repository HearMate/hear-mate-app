import subprocess
import os
import sys

if len(sys.argv) < 2:
    print("Usage: python scripts/update_model.py <REPO_PATH>")
    sys.exit(1)

REPO_PATH = sys.argv[1]
REQUIREMENTS_PATH = os.path.join(REPO_PATH, "requirements.txt")
ASSET_DIR = os.path.join("assets", "audiogram_classifier")
PLATFORMS = ["Darwin"]
# PLATFORMS = ["Darwin", "windows", "linux", "Pyodide", "android", "ios"]

os.makedirs(ASSET_DIR, exist_ok=True)

for platform in PLATFORMS:
    print(f"Packaging for {platform}...")
    output_zip = os.path.join(ASSET_DIR, f"audiogram_classifier_{platform}.zip")
    cmd = [
        "dart",
        "run",
        "serious_python:main",
        "package",
        REPO_PATH,
        "-p",
        platform,
        "--requirements",
        f"-r{REQUIREMENTS_PATH}",
        "--asset",
        output_zip,
    ]
    print(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd)
    if result.returncode != 0:
        print(f"Packaging failed for {platform}")
        sys.exit(1)
    print(f"Packaged {output_zip}")

print("All classifiers updated.")
