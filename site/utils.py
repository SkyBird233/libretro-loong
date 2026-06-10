from datetime import datetime
from json import load
from functools import reduce
from math import log
from posixpath import relpath
from pathlib import Path
from zipfile import ZipFile


class i18n:
    locales = ["en-US", "zh-CN"]

    def __init__(
        self, locale=locales[0], locale_dir=Path(__file__).resolve().parent / "i18n"
    ) -> None:
        self.locale = locale
        self.url_prefix = self.get_url_prefix(locale)

        with open(Path(locale_dir) / f"{self.locale}.json") as f:
            self.data = load(f)

    def _raise(self, e):
        raise e

    def get_url_prefix(self, locale):
        return "" if locale == i18n.locales[0] else locale.lower()

    def t(self, key: str):
        key_parts = key.split(".")
        return reduce(
            lambda x, y: x[y]
            if isinstance(x, dict) and y in x
            else self._raise(KeyError(f"i18n key not found: {key} ('{x}'['{y}'])")),
            key_parts,
            self.data,
        )

    def u(self, dst: str | Path, dst_locale: str = "", src: str | Path = "/") -> str:
        """Convert "absolute" URLs to relative ones"""
        assets = ["images", "nightly", "main.css"]

        # dst: relative or absolute (file)
        # src: absolute (file)
        src, dst = Path(src), Path(dst)
        if not src.is_absolute():
            raise ValueError("src must be an absolute path")
        if not dst.is_absolute():
            dst = src.parent / dst

        # Convert to locale-aware paths
        dst_prefix = Path(
            self.get_url_prefix(dst_locale) if dst_locale else self.url_prefix
        )
        src = Path(self.url_prefix) / src.relative_to(src.anchor)
        dst = (
            dst_prefix / dst.relative_to(dst.anchor)
            if len(dst.parts) > 1 and dst.parts[1] not in assets
            else dst.relative_to(dst.anchor)
        )

        # Calculate the final relative path
        return relpath(dst, src.parent)


def get_cores_meta(dist: Path, cores_url: str):
    def pretty_size(size):
        i = int(log(size, 1024))
        return f"{size / 1024**i:.2f} {['B', 'KiB', 'MiB', 'GiB'][i]}"

    def get_core_build_date(path: Path):
        with ZipFile(path, "r") as a:
            return datetime(*a.infolist()[0].date_time)

    cores = [
        {
            "url": f"/{cores_url}/{core.name}",
            "filename": core.name,
            "filemeta": [
                get_core_build_date(core).strftime("%Y-%m-%d %H:%M"),
                pretty_size(core.stat().st_size),
            ],
        }
        for core in (dist / cores_url).glob("*.so.zip")
    ]
    cores.sort(key=lambda core: core["filename"])
    return cores
