.venv:
	python3 -m venv .venv && .venv/bin/python -m pip install -r requirements-docs.txt

build: .venv
	.venv/bin/mkdocs build

serve: .venv
	.venv/bin/mkdocs serve