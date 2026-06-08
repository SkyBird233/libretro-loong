# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "jinja2>=3",
# ]
# ///

from datetime import datetime
from jinja2 import Environment, FileSystemLoader
from pathlib import Path
from utils import i18n, get_cores_meta


src_dir = Path(__file__).resolve().parent
dist = src_dir / "../_site"
cores_url = "nightly/linux/loongarch64/latest"


class Page:
    def __init__(self, title_key, iconUrl, url, context=lambda: {}) -> None:
        self.title_key = title_key
        self.iconUrl = iconUrl
        self.url = url
        self.context = context


pages = [
    Page(
        title_key="index.title",
        iconUrl="/images/menu_room_lan.svg",
        url="index.html",
    ),
    Page(
        title_key="quick-start.title",
        iconUrl="/images/menu_power.svg",
        url="quick-start.html",
    ),
    # Page(
    #     name="retroarch.title",
    #     iconUrl="/images/menu_saving.svg",
    #     url="retroarch.html",
    # ),
    Page(
        title_key="cores.title",
        iconUrl="/images/core.svg",
        url="cores.html",
        context=lambda: {"cores": get_cores_meta(dist, cores_url)},
    ),
    # Page(name="about.title", iconUrl="/images/menu_info.svg", url="about.html"),
]


def render_page(
    path: Path,
    environment: Environment,
    pages: list[Page],
    index: int,
    i18n_locale: i18n,
):
    page = pages[index]
    html = environment.get_template(page.url).render(
        {
            "pageTitle": i18n_locale.t(page.title_key),
            "navs": pages,
            "currentNav": page.url,
            "headerText": f"Built at {datetime.now().strftime('%Y-%m-%d %H:%M')}",
            **page.context(),
        }
    )

    html_dist = path / i18n_locale.url_prefix
    html_dist.mkdir(parents=True, exist_ok=True)
    with open(html_dist / page.url, "w") as f:
        f.write(html)


for locale in i18n.locales:
    environment = Environment(loader=FileSystemLoader(src_dir / "pages"))
    i18n_locale = i18n(locale)
    environment.globals.update(t=i18n_locale.t, u=i18n_locale.u)
    for i in range(len(pages)):
        render_page(dist, environment, pages, i, i18n_locale)
