.venv:
	virtualenv .venv && .venv/bin/pip install -r requirements-docs.txt

build: .venv
	.venv/bin/mkdocs build

serve: .venv
	.venv/bin/mkdocs serve