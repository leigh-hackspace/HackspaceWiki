# Leigh Hackspace Wiki

## Editing this wiki

Pages can be added under the `docs` folder.

All files are standard [Markdown](https://www.markdownguide.org/basic-syntax/) with a few extensions enabled by [mkdocs-material](https://squidfunk.github.io/mkdocs-material/). A full reference guide of the extra features can be found on the [references](https://squidfunk.github.io/mkdocs-material/reference/) page.

## Adding new sections to the navigation

The `nav` section in the `mkdocs.yaml` controls the navigation for the site. Check the structure and add as required.

## Using GitHub Codespaces

The repository contains a `.devcontainers.json` config file to configure Codespaces with all the required Python tooling and also some useful VSCode plugins. If you're using Codespaces you can follow the instructions on running `mkdocs` locally.

## Running `mkdocs` Locally

A `Makefile` exists to install and configure the dependencies for mkdocs. All that is required is a recent version of Python and `virtualenv` to be available.

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

Once running you can access your local `mkdocs` instance at http://127.0.0.1:8000/