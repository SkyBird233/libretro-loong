from datetime import datetime
from math import log
from pathlib import Path
from zipfile import ZipFile


def get_cores_meta(dist: Path, cores_url: str):
    def pretty_size(size):
        i = int(log(size, 1024))
        return f"{size / 1024**i:.2f} {['B', 'KiB', 'MiB', 'GiB'][i]}"

    def get_core_build_date(path: Path):
        with ZipFile(path, "r") as a:
            return datetime(*a.infolist()[0].date_time)

    cores = [
        {
            "url": f"{cores_url}/{core.name}",
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
