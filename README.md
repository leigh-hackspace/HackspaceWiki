# Leigh Hackspace Wiki

## Editing this wiki

Pages can be added under the `docs` folder, the navigation of the site is represented by the folder structure under this directory.

All files are standard [Markdown](https://www.markdownguide.org/basic-syntax/) with a few extensions enabled by [mkdocs-material](https://squidfunk.github.io/mkdocs-material/). A full reference guide of the extra features can be found on the [references](https://squidfunk.github.io/mkdocs-material/reference/) page.

## Running `mkdocs` Locally

A `Makefile` exists to install and configure the dependencies for mkdocs. All that is require is a recent version of Python and `virtualenv` to be available.

Running `make serve` will run a local, automatically updating instance of mkdocs on your system. This is useful to check any changes made before pushing them to the git repository.

```console
[nikdoof@Opux] (docs) % make serve
env/bin/mkdocs serve
INFO     -  Building documentation...
INFO     -  Cleaning site directory
INFO     -  Documentation built in 0.16 seconds
INFO     -  [20:03:09] Watching paths for changes: 'docs', 'mkdocs.yaml'
INFO     -  [20:03:09] Serving on http://127.0.0.1:8000/HackspaceWiki/
```
