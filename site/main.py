# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "jinja2>=3",
# ]
# ///

from datetime import datetime
from jinja2 import Environment, FileSystemLoader
from math import log
from pathlib import Path


src_dir = Path(__file__).resolve().parent
dist = src_dir / "../_site"
cores_url = "nightly/linux/loongarch64/latest"


class Page:
    def __init__(self, name, iconUrl, url, context=lambda: {}) -> None:
        self.name = name
        self.iconUrl = iconUrl
        self.url = url
        self.context = context


pages = [
    Page(
        name="主页",
        iconUrl="images/menu_room_lan.svg",
        url="index.html",
    ),
    # Page(
    #     name="模拟器",
    #     iconUrl="images/menu_saving.svg",
    #     url="retroarch.html",
    # ),
    Page(
        name="核心",
        iconUrl="images/core.svg",
        url="cores.html",
        context=lambda: {"cores": get_cores_meta(dist, cores_url)},
    ),
    # Page(name="关于", iconUrl="images/menu_info.svg", url="about.html"),
]


def pretty_size(size):
    i = int(log(size, 1024))
    return f"{size / 1024**i:.2f} {['B', 'KiB', 'MiB', 'GiB'][i]}"


def render_page(dist: Path, environment: Environment, pages: list[Page], index: int):
    page = pages[index]
    html = environment.get_template(page.url).render(
        {
            "pageTitle": page.name,
            "navs": pages,
            "currentNav": page.url,
            "footerText": "Footer",
            **page.context(),
        }
    )
    with open(dist / page.url, "w") as f:
        f.write(html)


def get_cores_meta(dist: Path, cores_url: str):
    cores = [
        {
            "url": f"{cores_url}/{core.name}",
            "filename": core.name,
            "filemeta": [
                datetime.fromtimestamp(core.stat().st_mtime).strftime("%Y-%m-%d %H:%M"),
                pretty_size(core.stat().st_size),
            ],
        }
        for core in (dist / cores_url).glob("*.so.zip")
    ]
    cores.sort(key=lambda core: core["filename"])
    return cores


environment = Environment(loader=FileSystemLoader(src_dir / "pages"))
for i in range(len(pages)):
    render_page(dist, environment, pages, i)
