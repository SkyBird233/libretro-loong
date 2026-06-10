# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "jinja2>=3",
# ]
# ///

from datetime import datetime
from functools import partial
from jinja2 import Environment, FileSystemLoader
from pathlib import Path
from utils import i18n, get_cores_meta


src_dir = Path(__file__).resolve().parent
pages_dir = src_dir / "pages"
dist = src_dir / "../_site"
cores_url = "nightly/linux/loongarch64/latest"

pages = [
    file.relative_to(pages_dir)
    for d in pages_dir.walk()
    for file in map(lambda f: d[0] / f, d[2])
    if file.suffix == ".html"
]
nav_pages = ["index", "quick-start", "cores", "settings"]
navs = [
    {
        "title_key": f"{name}.title",
        "icon_url": f"/images/{name}.svg",
        "url": Path(f"/{name}.html"),
    }
    for name in nav_pages
]
cores = get_cores_meta(dist, cores_url)
languages = [
    {"name": "English", "locale": "en-US"},
    {"name": "Simplified Chinese - 简体中文", "locale": "zh-CN"},
]


def render_page(
    dist: Path,
    page: Path,
    environment: Environment,
    i18n_locale: i18n,
):
    html = environment.get_template(str(page)).render(
        {
            "pageTitle": i18n_locale.t(
                f"{str(page.with_suffix('')).replace('/', '.')}.title"
            ),
            "navs": navs,
            "current_nav": Path(f"/{page.parent.name or page.stem}.html"),
            "headerText": f"Built at {datetime.now().strftime('%Y-%m-%d %H:%M')}",
            "cores": cores,
            "languages": languages,
        }
    )

    html_dist = dist / i18n_locale.url_prefix
    (html_dist / page.parent).mkdir(parents=True, exist_ok=True)
    with open(html_dist / page, "w") as f:
        f.write(html)


for locale in i18n.locales:
    environment = Environment(loader=FileSystemLoader(src_dir / "pages"))
    i18n_locale = i18n(locale)
    environment.globals["t"] = i18n_locale.t
    for page in pages:
        environment.globals["u"] = partial(
            i18n_locale.u, dst_locale=locale, src="/" / page
        )
        render_page(dist, page, environment, i18n_locale)
