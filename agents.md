# Repository guide for agents and contributors

> **Read [`CONTRIBUTING.md`](CONTRIBUTING.md) in full before making any change.**
> Its branch, commit, test, merge, and push rules are mandatory for every human
> and automated contributor. This guide complements it; it never overrides it.

## Keep this document alive

This is a living map of the repository. Update `agents.md` in the same change
whenever work alters the project structure, development workflow, build or
deployment process, generated files, or contributor-facing conventions. Remove
information that is no longer true rather than leaving historical guesses.

## Purpose and stack

This repository contains Kike's Quarto blog. It renders static HTML and
publishes it through GitHub Pages at `https://blog.kike.wtf`.

- **Site generator:** Quarto
- **Development environment:** Nix flake, loaded by direnv through `.envrc`
- **Hosting:** GitHub Pages
- **Continuous deployment:** GitHub Actions

There is currently no Node project or `package.json`; the `npm run check`
commands mentioned in `CONTRIBUTING.md` are therefore not available. The
available project validation is a successful Quarto render.

## Repository layout

```text
.github/workflows/publish-pages.yml  GitHub Pages build and deployment workflow
CNAME                                Custom domain published with the site
CONTRIBUTING.md                      Mandatory contribution rules
_quarto.yml                          Site-wide Quarto configuration
flake.nix / flake.lock               Reproducible Quarto development environment
.envrc                               Loads the Nix development environment via direnv
index.qmd                            Home page and post listing
styles.css                           Site-wide visual styling
posts/
  _metadata.yml                      Defaults and HTML includes applied to every post
  back-button.html                   Reading-page back control
  post-tools.html                    Reading stats and Copy to markdown behaviour
  YYYYMMDD/
    index.qmd                        A post's Quarto source
    img/                             Images used by that post
```

Posts use date-based directories in `posts/YYYYMMDD/`. Keep a post's images
inside its own `img/` directory and reference them relatively from its
`index.qmd`.

## Content and reading experience

- `_quarto.yml` defines the website URL, theme, common stylesheet, and which
  source files Quarto renders.
- `posts/_metadata.yml` automatically injects the back button and post tools
  into post pages. Do not duplicate those includes in individual post files.
- `posts/post-tools.html` generates the reading-time/token display and the
  **Copy to markdown** control in the browser. Image exports must use absolute
  URLs so copied Markdown works outside the site.
- `styles.css` contains both the home listing and post-reading layouts. Check
  desktop and mobile rendering when changing it.

## Local development and validation

With direnv installed, allow `.envrc`; otherwise enter the shell directly:

```bash
nix develop
quarto render
```

`quarto render` writes the generated website to `_site/`. It is intentionally
ignored and must not be committed. Use `quarto preview` when visual browser
checks are needed.

Other generated or local-only paths, such as `.quarto/`, `*_files/`,
`.playwright-mcp/`, and `.direnv/`, are also ignored through `.gitignore`.

## Deployment

`.github/workflows/publish-pages.yml` runs on pushes to `main` and on manual
dispatch. It renders the site, uploads `_site/` as the Pages artifact, and
deploys it with GitHub Pages actions. The workflow is configured to enable
Pages when needed.

`CNAME` contains `blog.kike.wtf`. Keep it aligned with the custom domain
configured in GitHub Pages and with `website.site-url` in `_quarto.yml`.

Do not change deployment behavior, the custom domain, or generated-file rules
without updating this guide and validating the Quarto render.
