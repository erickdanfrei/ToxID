"""Prepara oito fotos licenciadas na máquina de build. O app nunca baixa as fotos."""
from pathlib import Path
from urllib.parse import unquote, quote
from urllib.request import Request, urlopen
from io import BytesIO
import hashlib
import json
import time
from PIL import Image, ImageOps

root = Path(__file__).resolve().parents[1]
for entry in json.loads((root / "assets/data/creditos-fotos.json").read_text(encoding="utf-8")):
    target = root / "assets/visual" / (entry["id"] + ".webp")
    if target.exists():
        with Image.open(target) as im:
            im.verify()
        continue
    name = unquote(entry["source"].split("/wiki/")[1]).split(":", 1)[1].replace(" ", "_")
    digest = hashlib.md5(name.encode()).hexdigest()
    url = f"https://upload.wikimedia.org/wikipedia/commons/{digest[0]}/{digest[:2]}/{quote(name)}"
    request = Request(url, headers={"User-Agent": "ToxID-AcademicBuild/1.0 (offline educational catalog)"})
    for attempt in range(3):
        try:
            with urlopen(request, timeout=45) as response:
                data = response.read()
            break
        except OSError:
            if attempt == 2:
                raise
            time.sleep(3 * (attempt + 1))
    with Image.open(BytesIO(data)) as im:
        photo = ImageOps.exif_transpose(im).convert("RGB")
        photo.thumbnail((720, 720))
        temp = target.with_suffix(".tmp")
        photo.save(temp, format="WEBP", quality=82)
        temp.replace(target)
    print(entry["species"], target.stat().st_size, "bytes")
    time.sleep(1)
