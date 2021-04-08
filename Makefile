SHELL=/bin/bash
SRC = _src
CV_TEX := $(SRC)/cv.tex
CV_MD := index.md
GIT_REMOTE := $(shell git config remote.origin.url)
GH_API := https://api.github.com
BASE_URL := https://cmbuckley.co.uk

# Position and location for current role
ROLE_CUR := $(shell curl -su $(GIT_TOKEN) $(GH_API)/user | grep bio | cut -d '"' -f4)
ROLE_POS := $(shell awk -v col=4 -f $(SRC)/role.awk $(CV_TEX))
ROLE_LOC := $(shell awk -v col=8 -f $(SRC)/role.awk $(CV_TEX))

# Details for main site when updating role
SITE_REPO := cmbuckley/cmbuckley.github.io
SITE_DIR := ../cmbuckley.github.io
SITE_BRANCH := $(shell date +'role-%Y%m%d-%H%M%S')

.PHONY: pdf md travis clean spell check role travis_success

default: pdf md

check:
ifeq (, $(shell which aspell))
	$(error "Spell check requires aspell")
endif

pdf: $(CV_TEX)
	pdflatex -output-directory $(SRC) $(CV_TEX)
	mv $(SRC)/cv.pdf .

md: $(CV_TEX)
	cp $(SRC)/cv.md $(CV_MD)
	sed -i'.bak' "s/description:.*$$/&$(shell awk -f $(SRC)/summary.awk $(CV_TEX))/" $(CV_MD)
	awk -f $(SRC)/cv.awk $(CV_TEX) >> $(CV_MD)
	while IFS=: read interest link; \
		do sed -i'.bak' "s~$$interest~[&]($${link/ /})~" $(CV_MD); \
	done < _data/links.yml
	rm $(CV_MD).bak

clean:
	rm -rf $(CV_MD) cv.* $(SRC)/cv.{aux,log,out,toc} $(SITE_DIR)

spell: check md
	aspell list < $(CV_MD) | LANG=C sort -u

role: clean
ifeq ("$(ROLE_CUR)", "$(ROLE_POS) at $(ROLE_LOC)")
	@echo 'Role not changed'
else
	@echo "Current role: [$(ROLE_CUR)]"
	curl -X PATCH $(GH_API)/user -u $(GIT_TOKEN) -d '{"bio":"$(ROLE_POS) at $(ROLE_LOC)"}'

	git clone https://github.com/$(SITE_REPO) $(SITE_DIR)
	git -C $(SITE_DIR) checkout -b $(SITE_BRANCH)
	sed -i'.bak' '/company:/s/company: .*/company: $(subst &,\&,$(ROLE_LOC))/;/role:/s/role: .*/role: $(subst &,\&,$(ROLE_POS))/' $(SITE_DIR)/_config.yml
	git -C $(SITE_DIR) commit -am 'Update role from CV'
	git -C $(SITE_DIR) push "https://$(GIT_TOKEN)@github.com/$(SITE_REPO)" HEAD
	curl -X POST $(GH_API)/repos/$(SITE_REPO)/pulls -u $(GIT_TOKEN) \
		-d '{"title":"Update role from CV", "head":"$(SITE_BRANCH)", "base": "master"}'
endif

travis: default
ifeq ($(TRAVIS_PULL_REQUEST), true)
	@echo 'Travis target not executed for pull requests.'
else
	git config user.name $(GIT_NAME)
	git config user.email $(GIT_EMAIL)
	git add -f cv.pdf $(CV_MD)
	git commit -m 'Updated GitHub Pages'
	git push -f "https://$(GIT_TOKEN)@$(word 2,$(subst ://, ,$(GIT_REMOTE)))" HEAD:gh-pages
endif

purge:
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(CLOUDFLARE_ZONE)/purge_cache" \
		-H "Authorization: Bearer $(CLOUDFLARE_TOKEN)" \
		-H "Content-Type: application/json" \
		--data '{"files":["$(BASE_URL)/cv/"]}'

travis_success: role purge
