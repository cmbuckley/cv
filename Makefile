SRC = _src
CV_TEX := $(SRC)/cv.tex
GIT_REMOTE := $(shell git config remote.origin.url)

default: pdf md

pdf:
	pdflatex -output-directory $(SRC) $(CV_TEX)
	mv $(SRC)/cv.pdf .

md:
	awk -f $(SRC)/cv.awk $(CV_TEX) > cv.md

travis: default
ifeq ($(TRAVIS_PULL_REQUEST), true)
	@echo 'Travis target not executed for pull requests.'
else
	git config user.name $(GIT_NAME)
	git config user.email $(GIT_EMAIL)
	git add -f cv.pdf cv.md
	git commit -m 'Updated GitHub Pages'

#	hiding command & output due to GIT_TOKEN
	@git push -fq "https://$(GIT_TOKEN)@$(GIT_REMOTE:git://%=%)" HEAD:gh-pages >/dev/null 2>&1
endif
