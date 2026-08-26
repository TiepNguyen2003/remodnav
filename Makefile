# simple makefile to simplify repetetive build env management tasks under posix
# Ideas borrowed from scikit-learn's and PyMVPA Makefiles  -- thanks!

PYTHON ?= python

MODULE ?= remodnav

all: clean test

clean:
	-rm -rf dist build bin *.egg-info
	-find . -name '*.pyc' -delete
	-find . -name '__pycache__' -type d -delete

develop:
	$(PYTHON) -m pip install -e .

test-code: develop
	$(PYTHON) -m pytest -s -v $(MODULE)

test-coverage: develop
	rm -rf coverage .coverage
	$(PYTHON) -m pytest -s -v --cov=remodnav --cov-report=term-missing $(MODULE)

test: test-code


trailing-spaces:
	find $(MODULE) -name "*.py" -exec perl -pi -e 's/[ \t]*$$//' {} \;

code-analysis:
	flake8 $(MODULE) | grep -v __init__ | grep -v external
	pylint -E -i y $(MODULE)/ # -d E1103,E0611,E1101

#update-changelog:
#	@echo ".. This file is auto-converted from CHANGELOG.md (make update-changelog) -- do not edit\n\nChange log\n**********" > docs/source/changelog.rst
#	pandoc -t rst CHANGELOG.md >> docs/source/changelog.rst

release-pypi: # update-changelog
	# better safe than sorry
	test ! -e dist
	$(PYTHON) -m build
	twine upload dist/*
