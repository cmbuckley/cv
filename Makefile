SRC = _src
CV_TEX := $(SRC)/cv.tex
CV_MD := index.md
GIT_REMOTE := $(shell git config remote.origin.url)

.PHONY: pdf md travis clean spell check

default: pdf md

check:
ifeq (, $(shell which aspell))
	$(error "Spell check requires aspell")
endif

pdf: $(CV_TEX)
	pdflatex -output-directory $(SRC) $(CV_TEX)
	mv $(SRC)/cv.pdf .

md: $(CV_TEX)
	awk -f $(SRC)/cv.awk $(CV_TEX) > $(CV_MD)

clean:
	rm -f $(CV_MD) cv.* $(SRC)/cv.log $(SRC)/cv.aux

spell: check md
	aspell list < $(CV_MD) | LANG=C sort -u

travis: default
ifeq ($(TRAVIS_PULL_REQUEST), true)
	@echo 'Travis target not executed for pull requests.'
else
	git config user.name $(GIT_NAME)
	git config user.email $(GIT_EMAIL)
	git add -f cv.pdf $(CV_MD)
	git commit -m 'Updated GitHub Pages'

#	hiding command & output due to GIT_TOKEN
	git push -fq "https://$(GIT_TOKEN)@$(word 2,$(subst ://, ,$(GIT_REMOTE)))" HEAD:gh-pages >/dev/null 2>&1
endif

purge:
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(CLOUDFLARE_ZONE)/purge_cache" \
		-H "X-Auth-Email: $(CLOUDFLARE_EMAIL)" -H "X-Auth-Key: $(CLOUDFLARE_TOKEN)" \
		-H "Content-Type: application/json" --data '{"purge_everything":true}'
