"""Instala o wrapper oficial do próprio Flutter sem tocar no código do app."""
from pathlib import Path
from tempfile import TemporaryDirectory
import shutil
import subprocess

root = Path(__file__).resolve().parents[1]
flutter = shutil.which("flutter")
if not flutter:
    raise SystemExit("Instale Flutter e inclua flutter/bin no PATH.")
with TemporaryDirectory() as temp:
    template = Path(temp) / "wrapper_model"
    subprocess.run([flutter, "create", "--platforms=android", "--no-pub", str(template)], check=True)
    for name in ("gradlew", "gradlew.bat", "gradle/wrapper/gradle-wrapper.jar"):
        shutil.copy2(template / "android" / name, root / "android" / name)
