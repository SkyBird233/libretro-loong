# Website

This directory contains the source for the libretro-loong website. The site is generated as static HTML with Python and Jinja2.

## Build and preview

Run these commands from the repository root:

```sh
uv run site/main.py
cp -r site/public/. _site/
python3 -m http.server 8000 -d _site
```

Then open http://localhost:8000.

Page templates are in `pages/`, translations are in `i18n/`, and CSS and images are in `public/`. Generated files are written to `_site/` at the repository root.
