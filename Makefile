env:
	virtualenv env && env/bin/pip install -r requirements-docs.txt

build: env
	env/bin/mkdocs build

serve: env
	env/bin/mkdocs serve